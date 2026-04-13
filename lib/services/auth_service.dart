import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();

        final userModel = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );

        /// Save user to Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());

        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
    return null;
  }

  /// Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>);
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
    return null;
  }

  /// Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      // ignore: new_with_undefined_constructor_default, undefined_method
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      // Get authentication credentials
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken ?? '',
        idToken: googleAuth.idToken ?? '',
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          // Create new user document
          final userModel = UserModel(
            uid: user.uid,
            name: user.displayName ?? 'Unknown',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toJson());
          return userModel;
        } else {
          final data = doc.data();
          if (data != null) {
            return UserModel.fromJson(data);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred during Google Sign-In: ${e.toString()}';
    }
    return null;
  }

  /// Get user model by UID
  Future<UserModel?> getUserModel(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? photoUrl,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (location != null) updates['location'] = location;
      if (latitude != null) updates['latitude'] = latitude;
      if (longitude != null) updates['longitude'] = longitude;

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user model (complete user object update)
  Future<void> updateUserModel(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // ignore: new_with_undefined_constructor_default
      await GoogleSignIn().signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        /// Delete user document from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        /// Delete auth user
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase authentication exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-credential':
        return 'Invalid credentials.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}

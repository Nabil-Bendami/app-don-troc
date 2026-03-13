import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static const String _itemImagesPath = 'item_images';
  static const String _userPhotosPath = 'user_photos';

  /// Get the app's documents directory
  Future<Directory> _getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Create items images directory
  Future<Directory> _getItemImagesDir(String userId) async {
    final appDir = await _getAppDirectory();
    final dir = Directory('${appDir.path}/$_itemImagesPath/$userId');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Create user photos directory
  Future<Directory> _getUserPhotosDir(String userId) async {
    final appDir = await _getAppDirectory();
    final dir = Directory('${appDir.path}/$_userPhotosPath/$userId');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Upload item images to local storage
  /// Returns list of file paths instead of URLs
  Future<List<String>> uploadItemImages({
    required List<File> images,
    required String userId,
  }) async {
    try {
      const uuid = Uuid();
      final List<String> imagePaths = [];
      final itemImagesDir = await _getItemImagesDir(userId);

      for (final image in images) {
        final fileName = '${uuid.v4()}.jpg';
        final filePath = '${itemImagesDir.path}/$fileName';

        // Copy image to app directory
        final savedImage = await image.copy(filePath);
        imagePaths.add(savedImage.path);
      }

      return imagePaths;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload user profile photo to local storage
  Future<String?> uploadUserPhoto({
    required File photo,
    required String userId,
  }) async {
    try {
      final userPhotosDir = await _getUserPhotosDir(userId);
      const fileName = 'profile.jpg';
      final filePath = '${userPhotosDir.path}/$fileName';

      // Copy image to app directory
      final savedPhoto = await photo.copy(filePath);
      return savedPhoto.path;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete item image
  Future<void> deleteItemImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user photo
  Future<void> deleteUserPhoto(String userId) async {
    try {
      final userPhotosDir = await _getUserPhotosDir(userId);
      final profileFile = File('${userPhotosDir.path}/profile.jpg');
      if (await profileFile.exists()) {
        await profileFile.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get File object from path (for displaying images)
  File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  /// Check if image file exists
  Future<bool> imageExists(String imagePath) async {
    return await File(imagePath).exists();
  }
}

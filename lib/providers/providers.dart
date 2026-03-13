import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/index.dart';
import '../models/index.dart';
import 'mock_data.dart';

/// Service providers
final authServiceProvider = Provider((ref) => AuthService());
final firestoreServiceProvider = Provider((ref) => FirestoreService());
final storageServiceProvider = Provider((ref) => StorageService());

/// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current user model provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user != null) {
    return await authService.getUserModel(user.uid);
  }
  return null;
});

/// Items feed provider with pagination
final itemsFeedProvider = StreamProvider.autoDispose((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getItemsFeed();
});

/// User items provider
final userItemsProvider = StreamProvider.family<List<ItemModel>, String>((
  ref,
  userId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserItems(userId);
});

/// Search items provider
final searchItemsProvider = StreamProvider.family<List<ItemModel>, String>((
  ref,
  query,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.searchItems(query);
});

/// User chats provider
final userChatsProvider = StreamProvider.family<List<ChatModel>, String>((
  ref,
  userId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserChats(userId);
});

/// Chat messages provider
final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>((
  ref,
  chatId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getChatMessages(chatId);
});

/// Chat provider by ID
final chatProvider = FutureProvider.family<ChatModel?, String>((
  ref,
  chatId,
) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getChat(chatId);
});

/// Item provider by ID
final itemProvider = FutureProvider.family<ItemModel?, String>((
  ref,
  itemId,
) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getItem(itemId);
});

/// User posts provider (filtered by userId)
final userPostsProvider = StreamProvider.family<List<PostModel>, String>((
  ref,
  userId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserPosts(userId);
});

/// All posts provider (for global feed)
final allPostsProvider = StreamProvider<List<PostModel>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAllPosts();
});

// ============================================================================
// MOCK DATA PROVIDERS - For demonstration & debugging purposes
// ============================================================================

/// Mock sample items (for demo when database is empty)
final mockItemsProvider = Provider<List<ItemModel>>((ref) {
  return MockDataGenerator.generateSampleItems();
});

/// Mock sample posts (for demo when database is empty)
final mockPostsProvider = Provider<List<PostModel>>((ref) {
  return MockDataGenerator.generateSamplePosts();
});

/// Mock sample messages (for demo when database is empty)
final mockMessagesProvider = Provider.family<List<MessageModel>, String>((
  ref,
  chatId,
) {
  return MockDataGenerator.generateSampleMessages(chatId);
});

/// Mock sample chats (for demo when database is empty)
final mockChatsProvider = Provider<List<ChatModel>>((ref) {
  return MockDataGenerator.generateSampleChats();
});

/// Flag to enable mock data (useful for testing/demo)
final useMockDataProvider = StateProvider<bool>((ref) {
  // Set to true to always show mock data for testing
  return false;
});

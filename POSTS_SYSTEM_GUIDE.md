## Posts System Implementation Guide

### Overview
The posts system has been fully integrated with:
- **PostModel** for Firestore data structure
- **Seeding** with 5 demo posts on app startup (if collection is empty)
- **User-filtered queries** to show only current user's posts
- **Riverpod providers** for state management

---

## 1. Model Structure

### PostModel (`lib/models/post_model.dart`)
```dart
class PostModel {
  final String id;              // Unique post ID
  final String title;           // Post title
  final String description;     // Post content
  final String? image;          // Optional image URL
  final String userId;          // Creator's UID (Firebase Auth)
  final String userName;        // Creator's name
  final String? userPhotoUrl;   // Creator's profile photo
  final DateTime createdAt;     // Post creation time
}
```

**Firestore Collection Structure:**
```
posts/
├── doc_id_1
│   ├── id: "unique-id"
│   ├── title: "Beautiful vintage bike"
│   ├── description: "1970s road bike..."
│   ├── image: null
│   ├── userId: "auth-uid-123"
│   ├── userName: "Alex Johnson"
│   ├── userPhotoUrl: null
│   └── createdAt: Timestamp
├── doc_id_2
│   └── ...
```

---

## 2. Seeding Demo Data

### Automatic Seeding
Demo data is **automatically seeded on app startup** (`lib/main.dart`):
- Runs once when posts collection is empty
- Adds 5 sample posts with different creators
- Safe to run repeatedly (only seeds if collection is empty)

### Demo Posts
1. **Beautiful vintage bike for sale** - Alex Johnson
2. **Gaming laptop - barely used** - Sarah Williams
3. **Antique wooden desk** - Alex Johnson
4. **Camera equipment bundle** - Mike Chen
5. **Electric scooter - new condition** - Sarah Williams

---

## 3. Core Functions

### Add a Post
```dart
// In your screen/widget with ConsumerWidget/ConsumerStatefulWidget
final firestoreService = ref.read(firestoreServiceProvider);

final newPost = await firestoreService.addPost(
  title: 'My amazing item',
  description: 'Detailed description here',
  image: null,  // Optional: add image URL if available
  userId: currentUser.uid,
  userName: currentUser.name,
  userPhotoUrl: currentUser.photoUrl,
);
```

### Fetch User Posts (Filtered)
```dart
// Get only current user's posts
// In a ConsumerWidget/ConsumerStatefulWidget:
final userPostsAsync = ref.watch(userPostsProvider(userId));

userPostsAsync.when(
  data: (posts) {
    if (posts.isEmpty) {
      return const Text('No posts yet');
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          child: Column(
            children: [
              Text(post.title),
              Text(post.description),
              Text('by ${post.userName}'),
            ],
          ),
        );
      },
    );
  },
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### Fetch All Posts (Global Feed)
```dart
// Get all posts from all users
final allPostsAsync = ref.watch(allPostsProvider);

allPostsAsync.when(
  data: (posts) => _buildPostsList(posts),
  loading: () => const LoadingWidget(),
  error: (error, _) => ErrorWidget(message: error.toString()),
);
```

---

## 4. Usage Examples

### Example 1: Display User's Own Posts
```dart
class MyPostsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return currentUser.when(
      data: (user) {
        if (user == null) return const Text('Not logged in');
        
        final userPosts = ref.watch(userPostsProvider(user.uid));
        
        return userPosts.when(
          data: (posts) => ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.description),
                trailing: Text(post.createdAt.toString()),
              );
            },
          ),
          loading: () => const LoadingWidget(),
          error: (error, _) => Text('Error: $error'),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

### Example 2: Create a New Post
```dart
class CreatePostScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _createPost() async {
    final currentUser = await ref.read(currentUserProvider.future);
    if (currentUser == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    
    try {
      final newPost = await firestoreService.addPost(
        title: _titleController.text,
        description: _descriptionController.text,
        image: null,
        userId: currentUser.uid,
        userName: currentUser.name,
        userPhotoUrl: currentUser.photoUrl,
      );
      
      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created!')),
      );
      
      // Clear fields
      _titleController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Post title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            maxLines: 5,
          ),
          ElevatedButton(
            onPressed: _createPost,
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }
}
```

### Example 3: Filter by Different Users
```dart
// Display posts from a specific user
class UserProfilePostsScreen extends ConsumerWidget {
  final String userId;
  
  const UserProfilePostsScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPosts = ref.watch(userPostsProvider(userId));
    
    return userPosts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No posts from this user'));
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.image != null)
                      Image.network(post.image!, fit: BoxFit.cover),
                    SizedBox(height: 8),
                    Text(post.title, maxLines: 2),
                    Text(post.userName, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

---

## 5. Providers Reference

### `userPostsProvider(userId)`
- **Type:** `StreamProvider.family<List<PostModel>, String>`
- **Purpose:** Fetch posts filtered by specific userId
- **Usage:** Display a user's own posts or another user's posts
- **Real-time:** ✅ Updates automatically when posts change

```dart
final myPosts = ref.watch(userPostsProvider(currentUser.uid));
```

### `allPostsProvider`
- **Type:** `StreamProvider<List<PostModel>>`
- **Purpose:** Fetch all posts from all users (global feed)
- **Usage:** Display feed of all posts in the app
- **Real-time:** ✅ Updates automatically

```dart
final feed = ref.watch(allPostsProvider);
```

---

## 6. Service Methods

### `FirestoreService`

#### `seedDemoPosts()`
```dart
Future<void> seedDemoPosts()
```
- Checks if posts collection is empty
- Adds 5 demo posts if empty
- Safe to call multiple times (only seeds once)

#### `addPost()`
```dart
Future<PostModel> addPost({
  required String title,
  required String description,
  String? image,
  required String userId,
  required String userName,
  String? userPhotoUrl,
})
```
- Creates a new post in Firestore
- Returns the created PostModel
- Automatically generates unique ID

#### `getUserPosts(userId)`
```dart
Stream<List<PostModel>> getUserPosts(String userId)
```
- Returns a stream of posts filtered by userId
- Ordered by createdAt (newest first)
- Real-time updates via Firestore snapshots

#### `getAllPosts()`
```dart
Stream<List<PostModel>> getAllPosts()
```
- Returns a stream of all posts
- Ordered by createdAt (newest first)
- Real-time updates via Firestore snapshots

---

## 7. Privacy & Filtering

### How User Filtering Works
1. **When fetching user posts:** Use `userPostsProvider(userId)`
   - Only returns posts where `post.userId == userId`
   - SQL-like query: `WHERE userId = '$userId'`

2. **Display only current user's posts:**
   ```dart
   final currentUser = await ref.read(currentUserProvider.future);
   final myPosts = ref.watch(userPostsProvider(currentUser?.uid ?? ''));
   ```

3. **Display other user's posts:**
   ```dart
   final otherUserPosts = ref.watch(userPostsProvider('specific-user-uid'));
   ```

---

## 8. Troubleshooting

| Issue | Solution |
|-------|----------|
| No posts showing | Check if currentUser.uid is correct and posts exist with that userId |
| Demo posts not appearing | Ensure `seedDemoPosts()` ran successfully (check logs) |
| Posts real-time not updating | Make sure using `StreamProvider` (not `FutureProvider`) |
| Wrong user's posts showing | Verify userId parameter matches Firebase Auth UID |
| Collection structure wrong | Check Firestore has "posts" collection with correct fields |

---

## 9. Next Steps

- Add image upload functionality to `addPost()`
- Create UI components for post creation
- Add post deletion and editing
- Implement post interactions (likes, comments)
- Add pagination for large post lists


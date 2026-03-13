import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/index.dart';
import '../models/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: currentUserAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not authenticated'));
            }

            final userItemsAsync = ref.watch(userItemsProvider(user.uid));

            return SingleChildScrollView(
              child: Column(
                children: [
                  /// User info section
                  Container(
                    padding: const EdgeInsets.all(Constants.paddingLarge),
                    child: Column(
                      children: [
                        /// Profile picture
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppTheme.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          child: CircleAvatar(
                            radius: 58,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                user.photoUrl != null &&
                                    user.photoUrl!.isNotEmpty &&
                                    File(user.photoUrl!).existsSync()
                                ? FileImage(File(user.photoUrl!))
                                : null,
                            child:
                                user.photoUrl == null ||
                                    user.photoUrl!.isEmpty ||
                                    !File(user.photoUrl!).existsSync()
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppTheme.primaryColor,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: Constants.paddingMedium),

                        /// Name
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Constants.paddingSmall),

                        /// Email
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.secondaryColor),
                          textAlign: TextAlign.center,
                        ),
                        if (user.location != null) ...[
                          const SizedBox(height: Constants.paddingSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.location!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.secondaryColor),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: Constants.paddingMedium),

                        /// Edit Profile Button
                        ElevatedButton.icon(
                          onPressed: () => _showEditProfileDialog(context, ref, user),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// User's posts section
                  Padding(
                    padding: const EdgeInsets.all(Constants.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Posts',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextButton(
                              onPressed: () => context.push('/home/my-posts'),
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: Constants.paddingMedium),
                        _buildMyPostsSection(context, ref, user.uid),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// User's items section
                  Padding(
                    padding: const EdgeInsets.all(Constants.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Items',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: Constants.paddingMedium),
                        userItemsAsync.when(
                          data: (items) {
                            if (items.isEmpty) {
                              return const custom.EmptyWidget(
                                title: 'No items posted',
                                message:
                                    'Share your first item to help others!',
                                icon: Icons.inbox_outlined,
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Card(
                                  margin: const EdgeInsets.only(
                                    bottom: Constants.paddingMedium,
                                  ),
                                  child: ListTile(
                                    leading: item.imageUrls.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              Constants.borderRadiusSmall,
                                            ),
                                            child: _buildItemImage(
                                              item.imageUrls[0],
                                            ),
                                          )
                                        : const Icon(Icons.image),
                                    title: Text(item.title),
                                    subtitle: Text(item.location),
                                    trailing: PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          onTap: () => context.push(
                                            '/home/item/${item.id}',
                                          ),
                                          child: const Text('View'),
                                        ),
                                        PopupMenuItem(
                                          onTap: () => _deleteItem(
                                            context,
                                            ref,
                                            item.id,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                    onTap: () =>
                                        context.push('/home/item/${item.id}'),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const custom.LoadingWidget(
                            message: 'Loading items...',
                          ),
                          error: (error, stack) => custom.ErrorWidget(
                            message: error.toString(),
                            onRetry: () =>
                                ref.refresh(userItemsProvider(user.uid)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const custom.LoadingWidget(message: 'Loading profile...'),
          error: (error, stack) =>
              custom.ErrorWidget(message: error.toString()),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
              if (context.mounted) {
                context.go('/auth');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final locationController = TextEditingController(text: user.location ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: Constants.paddingMedium),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final authService = ref.read(authServiceProvider);
                final updatedUser = user.copyWith(
                  name: nameController.text.trim(),
                  location: locationController.text.trim().isEmpty 
                    ? null 
                    : locationController.text.trim(),
                );
                await authService.updateUserModel(updatedUser);
                
                // Invalidate the currentUserProvider to refresh UI
                ref.invalidate(currentUserProvider);
                
                if (context.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(BuildContext context, WidgetRef ref, String itemId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final firestoreService = ref.read(firestoreServiceProvider);
                await firestoreService.deleteItem(itemId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Build image widget from file path
  Widget _buildItemImage(String imagePath) {
    try {
      final file = File(imagePath);
      if (imagePath.isEmpty) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
          ),
          child: const Icon(Icons.image),
        );
      }

      if (file.existsSync()) {
        return Image.file(
          file,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  Constants.borderRadiusSmall,
                ),
              ),
              child: const Icon(Icons.image_not_supported),
            );
          },
        );
      } else {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
          ),
          child: const Icon(Icons.image_not_supported),
        );
      }
    } catch (e) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
        ),
        child: const Icon(Icons.image_not_supported),
      );
    }
  }

  /// Build my posts section
  Widget _buildMyPostsSection(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) {
    final userPostsAsync = ref.watch(userPostsProvider(userId));

    return userPostsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const custom.EmptyWidget(
            title: 'No posts yet',
            message: 'Start by creating your first post!',
            icon: Icons.article_outlined,
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length > 3 ? 3 : posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: Constants.paddingMedium),
              child: ListTile(
                title: Text(post.title),
                subtitle: Text(
                  post.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/home/post/${post.id}'),
              ),
            );
          },
        );
      },
      loading: () => const custom.LoadingWidget(message: 'Loading posts...'),
      error: (error, stack) => custom.ErrorWidget(
        message: error.toString(),
        onRetry: () => ref.refresh(userPostsProvider(userId)),
      ),
    );
  }
}

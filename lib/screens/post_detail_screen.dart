import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';
import '../config/index.dart';
import '../models/index.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;

  const PostDetailScreen({required this.postId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final allPostsAsync = ref.watch(allPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        elevation: 0,
        backgroundColor: AppTheme.cardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: allPostsAsync.when(
          data: (posts) {
            // Find the post by ID
            PostModel? post;
            try {
              post = posts.firstWhere((p) => p.id == postId);
            } catch (_) {
              return custom.ErrorWidget(
                message: 'Post not found',
                onRetry: () => ref.refresh(allPostsProvider),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Post header with user info
                  Row(
                    children: [
                      /// User avatar
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          post.userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.paddingMedium),

                      /// User name and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.userName,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _formatDate(post.createdAt),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.secondaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Constants.paddingLarge),

                  /// Post title
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: Constants.paddingMedium),

                  /// Post description
                  Text(
                    post.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: Constants.paddingLarge),

                  if (post.image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constants.borderRadiusMedium,
                      ),
                      child: Image.asset(
                        post.image!,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: Constants.paddingLarge),
                  ],

                  /// Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ActionButton(
                        icon: Icons.favorite_outline,
                        label: 'Like',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post liked!'),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        },
                      ),
                      _ActionButton(
                        icon: Icons.comment_outlined,
                        label: 'Comment',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Comments coming soon!'),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        },
                      ),
                      _ActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post shared!'),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: Constants.paddingLarge),

                  /// Contact button
                  currentUserAsync.when(
                    data: (currentUser) {
                      if (currentUser != null &&
                          currentUser.uid != post!.userId) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Message sender'),
                                  duration: Duration(milliseconds: 800),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: Constants.paddingMedium,
                              ),
                            ),
                            child: const Text(
                              'Contact Posted By',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    loading: () =>
                        const custom.LoadingWidget(message: 'Loading...'),
                    error: (error, stack) => const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
          loading: () => const custom.LoadingWidget(message: 'Loading post...'),
          error: (error, stack) => custom.ErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(allPostsProvider),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, size: 28), onPressed: onPressed),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

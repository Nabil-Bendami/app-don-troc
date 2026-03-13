import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';
import '../config/index.dart';

class PostsFeedScreen extends ConsumerWidget {
  const PostsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPostsAsync = ref.watch(allPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Posts'),
        elevation: 0,
        backgroundColor: AppTheme.cardColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allPostsProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: allPostsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return custom.EmptyWidget(
                title: 'No posts yet',
                message: 'Be the first to share something with the community!',
                icon: Icons.article_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onTap: () => context.push('/home/post/${post.id}'),
                );
              },
            );
          },
          loading: () =>
              const custom.LoadingWidget(message: 'Loading posts...'),
          error: (error, stack) => custom.ErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(allPostsProvider),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/create-post'),
        label: const Text('Create Post'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final dynamic post;
  final VoidCallback onTap;

  const PostCard({required this.post, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Constants.paddingMedium),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Post header with user info
            Padding(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: Row(
                children: [
                  /// User avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      post.userName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                          style: Theme.of(context).textTheme.titleMedium
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
            ),

            /// Post content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Post title
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Constants.paddingSmall),

                  /// Post description
                  Text(
                    post.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            /// Post footer with action buttons
            Padding(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 20,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: Constants.paddingSmall),
                      Icon(
                        Icons.comment_outlined,
                        size: 20,
                        color: AppTheme.secondaryColor,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: AppTheme.secondaryColor,
                  ),
                ],
              ),
            ),
          ],
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

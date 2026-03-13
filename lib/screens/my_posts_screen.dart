import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: currentUser.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not authenticated'));
            }

            final userPostsAsync = ref.watch(userPostsProvider(user.uid));

            return userPostsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        custom.EmptyWidget(
                          title: 'No posts yet',
                          message: 'Create your first post to get started!',
                          icon: Icons.edit_note,
                        ),
                        const SizedBox(height: Constants.paddingLarge),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/home/create-post'),
                          icon: const Icon(Icons.add),
                          label: const Text('Create Post'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return custom.PostCard(
                      post: post,
                      onTap: () {
                        // Navigate to post detail if needed
                      },
                      onDelete: () {
                        // Handle delete post
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Delete functionality coming soon'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () =>
                  const custom.LoadingWidget(message: 'Loading posts...'),
              error: (error, stack) => custom.ErrorWidget(
                message: error.toString(),
                onRetry: () => ref.refresh(userPostsProvider(user.uid)),
              ),
            );
          },
          loading: () => const custom.LoadingWidget(message: 'Loading user...'),
          error: (error, stack) =>
              custom.ErrorWidget(message: error.toString()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/home/create-post'),
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}

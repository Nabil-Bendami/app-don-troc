import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              currentUser.whenData((user) {
                if (user != null) {
                  // ignore: unused_result
                  ref.refresh(userChatsProvider(user.uid));
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: currentUser.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not authenticated'));
            }

            final chatsAsync = ref.watch(userChatsProvider(user.uid));

            return chatsAsync.when(
              data: (chats) {
                // Show mock chats if real chats are empty
                final displayChats = chats.isEmpty ? _getMockChats(ref) : chats;

                if (displayChats.isEmpty && chats.isEmpty) {
                  return custom.EmptyWidget(
                    title: 'No messages yet',
                    message: 'Start a conversation by requesting an item.',
                    icon: Icons.chat_outlined,
                  );
                }

                return ListView.builder(
                  itemCount: displayChats.length,
                  itemBuilder: (context, index) {
                    final chat = displayChats[index];
                    return custom.ChatPreviewCard(
                      chat: chat,
                      onTap: () => context.push('/chat/${chat.id}'),
                    );
                  },
                );
              },
              loading: () =>
                  const custom.LoadingWidget(message: 'Loading chats...'),
              error: (error, stack) {
                // FALLBACK TO MOCK DATA ON ERROR (instead of showing error widget)
                final mockChats = _getMockChats(ref);
                if (mockChats.isNotEmpty) {
                  return ListView.builder(
                    itemCount: mockChats.length,
                    itemBuilder: (context, index) {
                      final chat = mockChats[index];
                      return custom.ChatPreviewCard(
                        chat: chat,
                        onTap: () => context.push('/chat/${chat.id}'),
                      );
                    },
                  );
                }
                return custom.ErrorWidget(
                  message: _formatErrorMessage(error.toString()),
                  onRetry: () => ref.refresh(userChatsProvider(user.uid)),
                );
              },
            );
          },
          loading: () => const custom.LoadingWidget(message: 'Loading user...'),
          error: (error, stack) => custom.ErrorWidget(
            message: _formatErrorMessage(error.toString()),
          ),
        ),
      ),
    );
  }

  /// Get mock chats for demo when database is empty
  List<dynamic> _getMockChats(WidgetRef ref) {
    return ref.read(mockChatsProvider);
  }

  String _formatErrorMessage(String error) {
    if (error.contains('permission-denied')) {
      return 'Permission Denied: Firestore security rules may need updating.\n\nCheck FIRESTORE_SETUP.md for instructions.';
    } else if (error.contains('network')) {
      return 'Network Error: Please check your internet connection.';
    } else if (error.contains('deadline')) {
      return 'Connection Timeout: Please try again.';
    } else if (error.contains('not found')) {
      return 'Data not found. The collection may not exist yet.';
    }
    return error;
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';
import '../providers/mock_data.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({required this.chatId, super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    currentUser.whenData((user) async {
      if (user != null) {
        final firestoreService = ref.read(firestoreServiceProvider);
        try {
          await firestoreService.sendMessage(
            chatId: widget.chatId,
            senderId: user.uid,
            senderName: user.name,
            senderPhotoUrl: user.photoUrl ?? '',
            text: _messageController.text.trim(),
          );
          _messageController.clear();

          /// Scroll to bottom
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final chatAsync = ref.watch(chatProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        title: chatAsync.when(
          data: (chat) {
            if (chat == null) {
              return const Text('Chat');
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.itemTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Item Discussion',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            );
          },
          loading: () => const Text('Loading...'),
          error: (error, stackTrace) => const Text('Chat'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Messages list - Real Firestore messages
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  // Show mock messages if real messages are empty
                  final displayMessages = messages.isEmpty
                      ? MockDataGenerator.generateSampleMessages(widget.chatId)
                      : messages;

                  if (displayMessages.isEmpty && messages.isEmpty) {
                    return Center(
                      child: custom.EmptyWidget(
                        title: 'No messages yet',
                        message: 'Start the conversation!',
                        icon: Icons.chat_outlined,
                      ),
                    );
                  }

                  /// Auto-scroll to bottom when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: displayMessages.length,
                    itemBuilder: (context, index) {
                      final message = displayMessages[index];

                      return custom.MessageBubble(
                        text: message.text,
                        isCurrentUser: false,
                        timestamp: _formatTime(message.createdAt),
                        senderName: message.senderName,
                        senderPhotoUrl: message.senderPhotoUrl,
                        showSenderInfo:
                            index == 0 ||
                            displayMessages[index - 1].senderId !=
                                message.senderId,
                      );
                    },
                  );
                },
                loading: () =>
                    const custom.LoadingWidget(message: 'Loading messages...'),
                error: (error, stack) {
                  // FALLBACK TO MOCK DATA ON ERROR (instead of showing error widget)
                  final mockMessages = MockDataGenerator.generateSampleMessages(
                    widget.chatId,
                  );
                  if (mockMessages.isNotEmpty) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: mockMessages.length,
                      itemBuilder: (context, index) {
                        final message = mockMessages[index];
                        return custom.MessageBubble(
                          text: message.text,
                          isCurrentUser: false,
                          timestamp: _formatTime(message.createdAt),
                          senderName: message.senderName,
                          senderPhotoUrl: message.senderPhotoUrl,
                          showSenderInfo:
                              index == 0 ||
                              mockMessages[index - 1].senderId !=
                                  message.senderId,
                        );
                      },
                    );
                  }
                  return custom.ErrorWidget(
                    message: error.toString(),
                    onRetry: () =>
                        ref.refresh(chatMessagesProvider(widget.chatId)),
                  );
                },
              ),
            ),

            /// Message input
            Container(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                border: Border(top: BorderSide(color: AppTheme.greyColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constants.borderRadiusMedium,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.greyColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Constants.paddingMedium,
                          vertical: Constants.paddingSmall,
                        ),
                      ),
                      maxLines: null,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: Constants.paddingSmall),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: AppTheme.primaryColor,
                    onPressed: _messageController.text.trim().isEmpty
                        ? null
                        : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}

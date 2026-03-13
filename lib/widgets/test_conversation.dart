import 'package:flutter/material.dart';
import '../config/index.dart';
import 'message_bubble.dart';

class TestConversation extends StatelessWidget {
  const TestConversation({super.key});

  // Demo conversation data for testing
  static final List<Map<String, dynamic>> demoMessages = [
    {
      'senderId': 'user_1',
      'senderName': 'Alice Johnson',
      'senderPhotoUrl': '',
      'text': 'Bonjour! Est-ce que cet article est toujours disponible?',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 10)),
    },
    {
      'senderId': 'user_2',
      'senderName': 'You',
      'senderPhotoUrl': '',
      'text': 'Oui, il est disponible! Vous êtes intéressé?',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 8)),
    },
    {
      'senderId': 'user_1',
      'senderName': 'Alice Johnson',
      'senderPhotoUrl': '',
      'text': 'Oui, très intéressé. Quand pouvez-vous le montrer?',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'senderId': 'user_2',
      'senderName': 'You',
      'senderPhotoUrl': '',
      'text': 'Demain matin à 10h à la gare centrale, c\'est bon?',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 2)),
    },
    {
      'senderId': 'user_1',
      'senderName': 'Alice Johnson',
      'senderPhotoUrl': '',
      'text': 'Parfait! À demain 👍',
      'createdAt': DateTime.now(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Test badge
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Constants.paddingSmall),
          decoration: BoxDecoration(
            color: Colors.amber.withAlpha(51),
            border: Border(bottom: BorderSide(color: Colors.amber[700]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bug_report, color: Colors.amber[700], size: 18),
              const SizedBox(width: 8),
              Text(
                'Test Conversation - Vertical Layout Demo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
        ),

        /// Messages list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: Constants.paddingSmall,
            ),
            itemCount: demoMessages.length,
            itemBuilder: (context, index) {
              final message = demoMessages[index];
              final isCurrentUser = message['senderId'] == 'user_2';

              return MessageBubble(
                text: message['text'],
                isCurrentUser: isCurrentUser,
                timestamp: _formatTime(message['createdAt']),
                senderName: message['senderName'],
                senderPhotoUrl: message['senderPhotoUrl'],
                showSenderInfo:
                    index == 0 ||
                    demoMessages[index - 1]['senderId'] != message['senderId'],
              );
            },
          ),
        ),

        /// Info footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Constants.paddingMedium),
          decoration: BoxDecoration(
            color: AppTheme.greyColor,
            border: Border(top: BorderSide(color: AppTheme.secondaryColor)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vertical Conversation Layout Demo',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '• Messages displayed in vertical timeline\n'
                '• Current user messages aligned right (blue)\n'
                '• Other user messages aligned left (grey)\n'
                '• Sender names and avatars shown\n'
                '• Timestamps for each message\n'
                '• Auto-scroll to latest message',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

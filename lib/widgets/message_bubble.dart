import 'dart:io';
import 'package:flutter/material.dart';
import '../config/index.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isCurrentUser;
  final String timestamp;
  final String senderName;
  final String senderPhotoUrl;
  final bool showSenderInfo;

  const MessageBubble({
    required this.text,
    required this.isCurrentUser,
    required this.timestamp,
    required this.senderName,
    required this.senderPhotoUrl,
    this.showSenderInfo = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Constants.paddingSmall,
        horizontal: Constants.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          /// Sender info (name and avatar)
          if (showSenderInfo && !isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(bottom: Constants.paddingSmall),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        senderPhotoUrl.isNotEmpty &&
                            File(senderPhotoUrl).existsSync()
                        ? FileImage(File(senderPhotoUrl))
                        : null,
                    child:
                        senderPhotoUrl.isEmpty ||
                            !File(senderPhotoUrl).existsSync()
                        ? const Icon(Icons.person, size: 12)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    senderName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          /// Message bubble
          Align(
            alignment: isCurrentUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.paddingMedium,
                    vertical: Constants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppTheme.primaryColor
                        : AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadiusMedium,
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : AppTheme.textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(timestamp, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

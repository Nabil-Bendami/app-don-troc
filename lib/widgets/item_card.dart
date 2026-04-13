import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/index.dart';
import '../models/index.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ItemCard({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: Constants.paddingMedium),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with user info
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    /// User avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryColor,
                      backgroundImage:
                          item.userPhotoUrl != null &&
                              item.userPhotoUrl!.isNotEmpty &&
                              File(item.userPhotoUrl!).existsSync()
                          ? FileImage(File(item.userPhotoUrl!))
                          : null,
                      child:
                          item.userPhotoUrl == null ||
                              item.userPhotoUrl!.isEmpty ||
                              !File(item.userPhotoUrl!).existsSync()
                          ? Text(
                              item.userName.isNotEmpty
                                  ? item.userName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: Constants.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.userName,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('MMM dd, HH:mm').format(item.createdAt),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Title
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Constants.paddingSmall),

              /// Description
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Bottom row: Type badge & Location
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.type == ItemType.don
                            ? AppTheme.successColor.withValues(alpha: 0.15)
                            : AppTheme.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          Constants.borderRadiusSmall,
                        ),
                      ),
                      child: Text(
                        item.type == ItemType.don ? 'Don' : 'Troc',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.type == ItemType.don
                              ? AppTheme.successColor
                              : AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.paddingSmall),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppTheme.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

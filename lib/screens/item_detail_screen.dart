import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';
import '../models/index.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailScreen({required this.itemId, super.key});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(itemProvider(widget.itemId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const custom.EmptyWidget(
              title: 'Item not found',
              message: 'This item may have been deleted.',
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image carousel
                Stack(
                  children: [
                    /// Image
                    if (item.imageUrls.isNotEmpty)
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: PageView.builder(
                          onPageChanged: (index) =>
                              setState(() => _currentImageIndex = index),
                          itemCount: item.imageUrls.length,
                          itemBuilder: (context, index) {
                            final imagePath = item.imageUrls[index];
                            final file = File(imagePath);
                            if (file.existsSync()) {
                              return Image.file(
                                file,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              );
                            } else {
                              return const Icon(Icons.image_not_supported);
                            }
                          },
                        ),
                      )
                    else
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: AppTheme.greyColor,
                        child: const Icon(Icons.image, size: 80),
                      ),

                    /// Indicator dots
                    if (item.imageUrls.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            item.imageUrls.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? AppTheme.primaryColor
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Constants.paddingLarge),

                /// Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.paddingMedium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title and type badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: item.type == ItemType.don
                                  ? AppTheme.successColor.withAlpha(26)
                                  : AppTheme.primaryColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(
                                Constants.borderRadiusMedium,
                              ),
                            ),
                            child: Text(
                              item.type == ItemType.don ? 'Don' : 'Troc',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: item.type == ItemType.don
                                    ? AppTheme.successColor
                                    : AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Constants.paddingMedium),

                      /// Category and location
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.category,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: AppTheme.secondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Constants.paddingMedium),

                      /// Divider
                      Divider(color: AppTheme.greyColor),
                      const SizedBox(height: Constants.paddingMedium),

                      /// Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Constants.paddingSmall),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: Constants.paddingLarge),

                      /// Divider
                      Divider(color: AppTheme.greyColor),
                      const SizedBox(height: Constants.paddingMedium),

                      /// User info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: Constants.avatarRadius,
                                backgroundImage:
                                    item.userPhotoUrl != null &&
                                        File(item.userPhotoUrl!).existsSync()
                                    ? FileImage(File(item.userPhotoUrl!))
                                    : null,
                                child:
                                    item.userPhotoUrl == null ||
                                        !File(item.userPhotoUrl!).existsSync()
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(width: Constants.paddingMedium),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.userName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Posted ${_formatDate(item.createdAt)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: Constants.paddingXLarge),

                      /// Action button (only if not current user)
                      currentUser.when(
                        data: (user) {
                          if (user != null && user.uid != item.userId) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _handleContact(item, user),
                                icon: const Icon(Icons.message),
                                label: const Text('Demander'),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, stackTrace) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: Constants.paddingLarge),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const custom.LoadingWidget(message: 'Loading item...'),
        error: (error, stack) => custom.ErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(itemProvider(widget.itemId)),
        ),
      ),
    );
  }

  void _handleContact(ItemModel item, UserModel currentUser) async {
    /// Create or get chat
    final firestoreService = ref.read(firestoreServiceProvider);
    try {
      final chat = await firestoreService.createOrGetChat(
        userId1: currentUser.uid,
        userId2: item.userId,
        itemId: item.id,
        itemTitle: item.title,
      );

      if (mounted) {
        context.push('/chat/${chat.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

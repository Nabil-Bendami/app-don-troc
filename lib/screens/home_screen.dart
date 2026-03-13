import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsFeed = ref.watch(itemsFeedProvider);
    final allPosts = ref.watch(allPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.card_giftcard,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: Constants.paddingMedium),
            const Text('Don & Troc'),
          ],
        ),
        elevation: 0,
        backgroundColor: AppTheme.cardColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.secondaryColor,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(icon: Icon(Icons.shopping_bag), text: 'Items'),
            Tab(icon: Icon(Icons.article), text: 'Posts'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            /// Items Tab
            _buildItemsTab(itemsFeed),

            /// Posts Tab
            _buildPostsTab(allPosts),
          ],
        ),
      ),
      bottomNavigationBar: custom.BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _handleNavigation(index, context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/create-post'),
        label: const Text('Create Post'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildItemsTab(AsyncValue<List<dynamic>> itemsFeed) {
    return Column(
      children: [
        /// Search bar
        Padding(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () =>
                          setState(() => _searchController.clear()),
                    )
                  : null,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),

        /// Items feed
        Expanded(
          child: itemsFeed.when(
            data: (items) {
              // Show mock data if real data is empty
              final displayItems = items.isEmpty ? _getMockItems() : items;

              if (displayItems.isEmpty && items.isEmpty) {
                return const custom.EmptyWidget(
                  title: 'No items yet',
                  message: 'Start sharing items to help your community!',
                  icon: Icons.inbox_outlined,
                );
              }

              /// Filter by search
              final filteredItems = _searchController.text.isEmpty
                  ? displayItems
                  : displayItems
                        .where(
                          (item) => item.title.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          ),
                        )
                        .toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.paddingMedium,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return custom.ItemCard(
                    item: item,
                    onTap: () => context.push('/home/item/${item.id}'),
                  );
                },
              );
            },
            loading: () =>
                const custom.LoadingWidget(message: 'Loading items...'),
            error: (error, stack) {
              // FALLBACK TO MOCK DATA ON ERROR (instead of showing error widget)
              final mockItems = _getMockItems();
              if (mockItems.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.paddingMedium,
                  ),
                  itemCount: mockItems.length,
                  itemBuilder: (context, index) {
                    final item = mockItems[index];
                    return custom.ItemCard(
                      item: item,
                      onTap: () => context.push('/home/item/${item.id}'),
                    );
                  },
                );
              }
              return custom.ErrorWidget(
                message: _formatErrorMessage(error.toString()),
                onRetry: () => ref.refresh(itemsFeedProvider),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Get mock items for demo when database is empty
  List<dynamic> _getMockItems() {
    return ref.read(mockItemsProvider);
  }

  Widget _buildPostsTab(AsyncValue<List<dynamic>> allPosts) {
    return allPosts.when(
      data: (posts) {
        // Show mock posts if real posts are empty
        final displayPosts = posts.isEmpty ? _getMockPosts() : posts;

        if (displayPosts.isEmpty && posts.isEmpty) {
          return const custom.EmptyWidget(
            title: 'No posts yet',
            message: 'Be the first to share something with the community!',
            icon: Icons.article_outlined,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          itemCount: displayPosts.length,
          itemBuilder: (context, index) {
            final post = displayPosts[index];
            return _buildPostCard(context, post);
          },
        );
      },
      loading: () => const custom.LoadingWidget(message: 'Loading posts...'),
      error: (error, stack) {
        // FALLBACK TO MOCK DATA ON ERROR (instead of showing error widget)
        final mockPosts = _getMockPosts();
        if (mockPosts.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(Constants.paddingMedium),
            itemCount: mockPosts.length,
            itemBuilder: (context, index) {
              final post = mockPosts[index];
              return _buildPostCard(context, post);
            },
          );
        }
        return custom.ErrorWidget(
          message: _formatErrorMessage(error.toString()),
          onRetry: () => ref.refresh(allPostsProvider),
        );
      },
    );
  }

  /// Get mock posts for demo when database is empty
  List<dynamic> _getMockPosts() {
    return ref.read(mockPostsProvider);
  }

  Widget _buildPostCard(BuildContext context, dynamic post) {
    return Card(
      margin: const EdgeInsets.only(bottom: Constants.paddingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: () => context.push('/home/post/${post.id}'),
        borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Post header with user info
              Row(
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
              const SizedBox(height: Constants.paddingMedium),

              /// Post title
              Text(
                post.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Constants.paddingSmall),

              /// Post description
              Text(
                post.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 18,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: Constants.paddingSmall),
                      Icon(
                        Icons.comment_outlined,
                        size: 18,
                        color: AppTheme.secondaryColor,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ],
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

  void _handleNavigation(int index, BuildContext context) {
    switch (index) {
      case 0:
        break;

      /// Already on home
      case 1:
        context.push('/home/add-item');
        setState(() => _selectedIndex = 0);
        break;
      case 2:
        context.push('/messages');
        break;
      case 3:
        context.push('/activity');
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }
}

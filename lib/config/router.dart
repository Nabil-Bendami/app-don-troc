import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/index.dart';
import '../providers/providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/auth';

      return authState.when(
        data: (user) {
          if (user != null) {
            return isLoggingIn ? '/home' : null;
          }
          return isLoggingIn ? null : '/auth';
        },
        loading: () => '/splash',
        error: (err, stack) => '/auth',
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AuthScreen()),
        routes: [
          GoRoute(
            path: 'signup',
            pageBuilder: (context, state) =>
                const MaterialPage(child: SignUpScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) =>
            const MaterialPage(child: HomeScreen()),
        routes: [
          GoRoute(
            path: 'item/:itemId',
            pageBuilder: (context, state) => MaterialPage(
              child: ItemDetailScreen(itemId: state.pathParameters['itemId']!),
            ),
          ),
          GoRoute(
            path: 'add-item',
            pageBuilder: (context, state) =>
                const MaterialPage(child: AddItemScreen()),
          ),
          GoRoute(
            path: 'my-posts',
            pageBuilder: (context, state) =>
                const MaterialPage(child: MyPostsScreen()),
          ),
          GoRoute(
            path: 'create-post',
            pageBuilder: (context, state) =>
                const MaterialPage(child: CreatePostScreen()),
          ),
          GoRoute(
            path: 'posts',
            pageBuilder: (context, state) =>
                const MaterialPage(child: PostsFeedScreen()),
          ),
          GoRoute(
            path: 'post/:postId',
            pageBuilder: (context, state) => MaterialPage(
              child: PostDetailScreen(postId: state.pathParameters['postId']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/chat/:chatId',
        pageBuilder: (context, state) => MaterialPage(
          child: ChatScreen(chatId: state.pathParameters['chatId']!),
        ),
      ),
      GoRoute(
        path: '/messages',
        pageBuilder: (context, state) =>
            const MaterialPage(child: MessagesScreen()),
      ),
      GoRoute(
        path: '/activity',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ActivityScreen()),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ProfileScreen()),
      ),
    ],
  );
});

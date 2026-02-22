import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/launchpad/launchpad.dart';
import 'package:flutterconf/profile/view/profile_page.dart';
import 'package:flutterconf/profile/view/public_profile_page.dart';
import 'package:flutterconf/profile/view/qr_connect_page.dart';
import 'package:flutterconf/profile/view/scanned_history_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final isLoggingIn = state.uri.path == '/login';
        final isAuthenticated =
            authState is Authenticated || authState is Guest;

        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }

        if (isAuthenticated && isLoggingIn) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LaunchpadPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/scan-qr',
          builder: (context, state) => const QRConnectPage(),
        ),
        GoRoute(
          path: '/scanned-history',
          builder: (context, state) => const ScannedHistoryPage(),
        ),
        GoRoute(
          path: '/profile/:id',
          builder: (context, state) {
            final userId = state.pathParameters['id']!;
            return PublicProfilePage(userId: userId);
          },
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

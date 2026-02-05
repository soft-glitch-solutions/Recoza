import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/screens/auth/signup_screen.dart';
import 'package:myapp/screens/main_screen.dart';
import 'package:myapp/screens/profile/privacy_policy_screen.dart';
import 'package:myapp/screens/profile/terms_screen.dart';
import 'package:myapp/services/auth_service.dart';

class AppRouter {
  final AuthService authService;

  AppRouter(this.authService);

  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
       GoRoute(
        path: '/notifications',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Notifications Screen'))),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsScreen(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authService.authStateChanges.isBroadcast;
      final loggingIn = state.matchedLocation == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';

      final loggingUp = state.matchedLocation == '/signup';
      if (!loggedIn) return loggingUp ? null : '/login';

      if (loggingIn || loggingUp) return '/';

      return null;
    },
  );
}

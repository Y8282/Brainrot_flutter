import 'package:brainrot_flutter/login/views/signupView.dart';
import 'package:brainrot_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brainrot_flutter/login/views/loginView.dart';
import 'package:brainrot_flutter/login/views/homeView.dart';
import 'package:brainrot_flutter/login/views/settingView.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (BuildContext context, GoRouterState state) async {
      final isAuthenticated =
          await ref.read(authServiceProvider).isAuthenticated();
      final loggingIn = state.uri.toString() == '/login';

      if (!isAuthenticated && !loggingIn) return '/login';
      if (isAuthenticated && loggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => Loginview(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => Signupview(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => Homeview(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => Settingview(),
      ),
    ],
  );
});

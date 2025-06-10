import 'package:brainrot_flutter/home/views/homeView.dart';
import 'package:brainrot_flutter/home/model/makeImageView.dart';
import 'package:brainrot_flutter/login/views/signupView.dart';
import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:brainrot_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brainrot_flutter/login/views/loginView.dart';
import 'package:brainrot_flutter/home/views/imageView.dart';

// 라우팅 설정
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (BuildContext context, GoRouterState state) async {
      final isAuthenticated =
          await ref.read(authServiceProvider).isAuthenticated();
      final loggingIn = state.uri.toString();
      final publicRoutes = ['/login', '/signup', '/findPassword', '/findId'];
      if (!isAuthenticated && !publicRoutes.contains(loggingIn))
        return '/login';
      if (isAuthenticated && publicRoutes.contains(loggingIn)) return '/home';
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
        path: '/findPassword',
        builder: (context, state) => Homeview(),
      ),
      GoRoute(
        path: '/findId',
        builder: (context, state) => Homeview(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => Homeview(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => Homeview(),
      ),
      GoRoute(
        path: '/makeImage',
        builder: (context, state) => Makeimageview(),
      ),
      GoRoute(
        path: '/detailImage',
        builder: (context, state) => Homeview(),
      )
    ],
  );
});

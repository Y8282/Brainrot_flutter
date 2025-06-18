import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:brainrot_flutter/services/http_json_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService extends ChangeNotifier {
  final Ref _ref;

  AuthService(this._ref);

  Future<void> login({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    final username = parameters['username']?.toString();
    final password = parameters['password']?.toString();
    
    final data = {
      'username': username,
      'password': password,
      'requestId': requestId,
    };
    // print('Login request data: $data'); // 요청 본문 로그
    await _ref.read(httpJsonServiceProvider).sendRequest(
          method: HttpMethod.POST,
          url: '/api/auth/login',
          data: data,
          requestId: requestId,
          callback: callback,
        );
  }

  Future<void> signup({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    final data = {
      'username': parameters['username'],
      'email': parameters['email'],
      'password': parameters['password'],
      'requestId': requestId
    };

    final response = await _ref.read(httpJsonServiceProvider).sendRequest(
        method: HttpMethod.POST,
        url: '/api/auth/signup',
        data: data,
        requestId: requestId,
        callback: callback);
  }

  Future<void> logout(BuildContext context) async {
    await _ref.read(authTokenProvider.notifier).clearToken();
    context.go('/login');
  }

  Future<bool> isAuthenticated() async {
    final token = _ref.read(authTokenProvider);
    print('Checking isAuthenticated, token: $token');
    return token != null;
  }
}

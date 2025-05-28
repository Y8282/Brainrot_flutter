import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:brainrot_flutter/services/http_json_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref _ref;

  AuthService(this._ref);

  Future<void> login({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
      method: HttpMethod.POST,
      url: '/auth/login',
      data: {'parameters': parameters},
      requestId: requestId,
      callback: (status, data, reqId, context) async {
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          final token = data['token'];
          await _ref.read(authTokenProvider.notifier).saveToken(token);
          callback(status, data, reqId, context);
        } else {
          callback('ERROR', {'message': data['resultMessage'] ?? 'Login failed'}, reqId, context);
        }
      },
    );
  }

  Future<void> logout() async {
    await _ref.read(authTokenProvider.notifier).clearToken();
  }

  Future<bool> isAuthenticated() async {
    final token = _ref.read(authTokenProvider);
    return token != null;
  }
}
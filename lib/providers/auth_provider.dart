import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// SecureStorage 인스턴스
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// 인증 토큰 provider
final authTokenProvider = StateNotifierProvider<AuthProvider, String?>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthProvider(storage);
});

class AuthProvider extends StateNotifier<String?> {
  final FlutterSecureStorage _storage;
  static const _key = 'auth_token';

  AuthProvider(this._storage) : super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _storage.read(key: _key);

    if (token != null && await isExpiredToken(token)) {
      await clearToken();
      state = null;
      print('Expire delte token : $token');
    } else {
      print('Loaded token on init: $token');
      state = token;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _key, value: token);
      state = token;
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _key);
    state = null;
  }

  // 토큰 만료시간 설정
  Future<bool> isExpiredToken(String token) async {
    final parse = token.split('.');
    if (parse.length != 3) return true;
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parse[1])));
    final exp = jsonDecode(payload)['exp'];
    final now = DateTime.now().microsecondsSinceEpoch ~/ 1000;
    return exp != null && now >= exp;
  }
}

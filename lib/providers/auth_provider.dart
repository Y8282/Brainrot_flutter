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
    print('Loaded token on init: $token');
    state = token;
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
}

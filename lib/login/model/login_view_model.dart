import 'package:brainrot_flutter/services/auth_services.dart';
import 'package:brainrot_flutter/widget/navistate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class LoginViewState {
  final bool isLoading;
  final String? errorMessage;

  const LoginViewState({
    this.isLoading = false,
    this.errorMessage,
  });

  LoginViewState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginViewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginViewState>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends StateNotifier<LoginViewState> {
  final Ref _ref;

  // Editing
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginViewModel(this._ref) : super(const LoginViewState()) {
    initialize();
  }

  void initialize() {
    state = const LoginViewState(isLoading: false, errorMessage: null);
  }

  // 로그인 요청
  Future<void> login(
      String username, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final requestId = 'login';
    final parameters = {
      'username': username,
      'password': password,
    };
    print('Login parameters: $parameters'); // 파라미터 로그
    await _ref.read(authServiceProvider).login(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, reqId, _) =>
              handleCallback(status, data, reqId, context),
        );
  }

  void handleCallback(
      String status, dynamic data, String requestId, BuildContext? context) {
    print('HandleCallback: status=$status, data=$data, requestId=$requestId');
    if (context == null) {
      state = state.copyWith(isLoading: false, errorMessage: 'UI 업데이트 실패');
      return;
    }

    switch (requestId) {
      case 'login':
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false);
          // GoRouter로 리다이렉트
        } else {
          final message = data['resultCode'] == '500'
              ? data['resultMessage'] ?? '로그인 실패'
              : '시스템 에러입니다.\n관리자에게 문의 바랍니다.';
          state = state.copyWith(isLoading: false, errorMessage: message);
          print('Showing SnackBar: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), duration: Duration(seconds: 3)),
          );
        }
        break;
      default:
        print('Unknown requestId: $requestId');
        state = state.copyWith(isLoading: false, errorMessage: '잘못된 요청');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('잘못된 요청'), duration: Duration(seconds: 3)),
        );
    }
  }
}

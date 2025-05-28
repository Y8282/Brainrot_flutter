import 'package:brainrot_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class LoginViewState{
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




final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginViewState>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends StateNotifier<LoginViewState> {
  final Ref _ref;

  LoginViewModel(this._ref) : super(const LoginViewState()) {
    initialize();
  }

  void initialize() {
    state = const LoginViewState(
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<void> login(String username, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final requestId = const Uuid().v4();
    final parameters = {
      'username': username,
      'password': password,
    };

    await _ref.read(authServiceProvider).login(
      parameters: parameters,
      requestId: requestId,
      callback: (status, data, reqId, _) {
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false);
          // GoRouter가 리다이렉트 처리
        } else {
          final message = data['resultCode'] == '500'
              ? data['resultMessage']
              : '시스템 에러입니다.\n관리자에게 문의 바랍니다.';
          state = state.copyWith(
            isLoading: false,
            errorMessage: message,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    );
  }
}
import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:brainrot_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    StateNotifierProvider.autoDispose<LoginViewModel, LoginViewState>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends StateNotifier<LoginViewState> {
  final Ref _ref;

  // Editing
  final TextEditingController loginUsername = TextEditingController();        // 로그인 이름 -> 나중에 이메일로 변경
  final TextEditingController loginPassword = TextEditingController();        // 로그인 패스워드

  // Signup Editing
  // Editing
  final TextEditingController SignupName = TextEditingController();           // 회원가입 이름
  final TextEditingController SignupEmail = TextEditingController();          // 회원가입 이메일
  final TextEditingController SignupPassword = TextEditingController();       // 회원가입 패스워드
  final TextEditingController SignupCheckpassword = TextEditingController();  // 회원가입 패스워드 확인

  LoginViewModel(this._ref) : super(const LoginViewState()) {
    initialize();
  }

  void initialize() {
    state = const LoginViewState(isLoading: false, errorMessage: null);
    loginUsername.text = '';
    loginPassword.text = '';
    SignupName.text = '';
    SignupEmail.text = '';
    SignupPassword.text = '';
    SignupCheckpassword.text = '';
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

  // 회원가입 요청
  Future<void> signup(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final requestId = 'signup';
    if (SignupPassword.text != SignupCheckpassword.text) {
      state =
          state.copyWith(isLoading: false, errorMessage: "비밀번호가 일치하지 않습니다.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
      );
      return;
    }

    if (SignupName.text.isEmpty ||
        SignupEmail.text.isEmpty ||
        SignupPassword.text.isEmpty ||
        SignupCheckpassword.text.isEmpty) {
      state = state.copyWith(isLoading: false, errorMessage: "모든 칸을 입력해주세요.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("모든 칸을 입력해주세요.")),
      );
      return;
    }

    // 이메일 형식 검증
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(SignupEmail.text.trim())) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '유효한 이메일 형식을 입력해주세요.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 이메일 형식을 입력해주세요.')),
      );
      return;
    }

    final data = {
      'username': SignupName.text.trim(),
      'email': SignupEmail.text.trim(),
      'password': SignupPassword.text,
      'requestId': requestId
    };
    print('회원가입 : ${data}');

    await _ref.read(authServiceProvider).signup(
          parameters: data,
          requestId: requestId,
          callback: (status, data, reqId, _) =>
              handleCallback(status, data, reqId, context),
        );
  }

  // api
  Future<void> handleCallback(String status, dynamic data, String requestId,
      BuildContext? context) async {
    print('HandleCallback: status=$status, data=$data, requestId=$requestId');
    if (context == null) {
      state = state.copyWith(isLoading: false, errorMessage: 'UI 업데이트 실패');
      return;
    }

    switch (requestId) {
      case 'login':
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false);

          //토큰 추출
          final token = data['resultData']?['token'];

          if (token != null) {
            try {
              await _ref.read(authTokenProvider.notifier).saveToken(token);
              final readToken = await _ref
                  .read(secureStorageProvider)
                  .read(key: 'auth_token');
              final isAuth =
                  await _ref.read(authServiceProvider).isAuthenticated();
              print(isAuth);
              if (isAuth && context.mounted) {
                context.go('/home');
              } else {
                state = state.copyWith(
                    isLoading: false, errorMessage: '인증상태 확인 실패');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('인증 상태 확인 실패'),
                  duration: Duration(seconds: 3),
                ));
              }
            } catch (e) {
              print('토큰 에러 : $e');
              state = state.copyWith(
                  isLoading: false, errorMessage: '토큰 저장 실패: $e');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('토큰 저장 실패'), duration: Duration(seconds: 3)));
            }
          }
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
      case 'signup':
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("회원가입 성공!")),
          );
          if (context.mounted) {
            context.go('/login');
          }
        } else {
          final message = data['resultCode'] == '500'
              ? data['resultCode'] ?? '회원가입 실패'
              : '시스템 에러입니다 \n 관리자에게 문의바랍니다.';
          state = state.copyWith(isLoading: false, errorMessage: message);
          print("로그인 에러 $message");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      default:
        print('Unknown requestId: $requestId');
        state = state.copyWith(isLoading: false, errorMessage: '잘못된 요청');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('잘못된 요청'), duration: Duration(seconds: 3)),
        );
    }
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
    loginUsername.dispose();
    loginPassword.dispose();
    SignupName.dispose();
    SignupEmail.dispose();
    SignupPassword.dispose();
    SignupCheckpassword.dispose();
  }
}

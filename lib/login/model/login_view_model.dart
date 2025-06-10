import 'package:brainrot_flutter/common/CommonDialog.dart';
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
  final TextEditingController loginUsername =
      TextEditingController(); // 로그인 이름 -> 나중에 이메일로 변경
  final TextEditingController loginPassword =
      TextEditingController(); // 로그인 패스워드

  // Signup Editing
  // Editing
  final TextEditingController signupName = TextEditingController(); // 회원가입 이름
  final TextEditingController signupEmail = TextEditingController(); // 회원가입 이메일
  final TextEditingController signupPassword =
      TextEditingController(); // 회원가입 패스워드
  final TextEditingController signupCheckpassword =
      TextEditingController(); // 회원가입 패스워드 확인

  late Map<String, TextEditingController> fields;
  late Map<String, FocusNode> focusNodes;
  // 포커스 노드
  final FocusNode signupNameFocus = FocusNode();
  final FocusNode signupEmailFocus = FocusNode();
  final FocusNode signupPasswordFocus = FocusNode();
  final FocusNode signupCheckPasswordFocus = FocusNode();

  LoginViewModel(this._ref) : super(const LoginViewState()) {
    initialize();
  }

  void initialize() {
    state = const LoginViewState(isLoading: false, errorMessage: null);
    loginUsername.text = '';
    loginPassword.text = '';
    signupName.text = '';
    signupEmail.text = '';
    signupPassword.text = '';
    signupCheckpassword.text = '';

    fields = {
      '이름': signupName,
      '이메일': signupEmail,
      '비밀번호': signupPassword,
      '비밀번호 확인': signupCheckpassword
    };
    focusNodes = {
      '이름': signupNameFocus,
      '이메일': signupEmailFocus,
      '비밀번호': signupPasswordFocus,
      '비밀번호 확인': signupCheckPasswordFocus,
    };
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

    for (var entry in fields.entries) {
      if (entry.value.text.trim().isEmpty) {
        state = state.copyWith(isLoading: false, errorMessage: "모든 칸을 입력해주세요.");
        openDialog(context, message: '${entry.key}을 입력해주세요.', onConfirmed: () {
          focusNodes[entry.key]!.requestFocus();
        });
        return;
      }
    }

    if (signupPassword.text != signupCheckpassword.text) {
      state =
          state.copyWith(isLoading: false, errorMessage: "비밀번호가 일치하지 않습니다.");
      openDialog(context, message: '비밀번호가 일치하지 않습니다.', onConfirmed: () {
        signupCheckPasswordFocus.requestFocus();
      });
      return;
    }

    // 이메일 형식 검증
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(signupEmail.text.trim())) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '유효한 이메일 형식을 입력해주세요.',
      );
      openDialog(
        context,
        message: "유효한 이메일 형식을 입력해주세요.",
        buttonType: MessageBottomButtonType.yes,
        type: MessagePopupType.information,
        onConfirmed: () {
          signupEmail.clear();
          signupEmailFocus.requestFocus();
        },
      );
      return;
    }

    final data = {
      'username': signupName.text.trim(),
      'email': signupEmail.text.trim(),
      'password': signupPassword.text,
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
                openDialog(context, message: "인증 상태 확인 실패", onConfirmed: () {
                  return;
                });
              }
            } catch (e) {
              print('토큰 에러 : $e');
              state = state.copyWith(
                  isLoading: false, errorMessage: '토큰 저장 실패: $e');
              openDialog(context, message: '토큰 저장 실패', onConfirmed: () {
                return;
              }, type: MessagePopupType.warning);
            }
          } else {
            final message = data['resultCode'] == '500'
                ? data['resultMessage'] ?? '로그인 실패'
                : '시스템 에러입니다.\n관리자에게 문의 바랍니다.';
            state = state.copyWith(isLoading: false, errorMessage: message);
            print('Showing SnackBar: $message');
            openDialog(context, message: '로그인 실패', onConfirmed: () {
              return;
            }, type: MessagePopupType.warning);
          }
        } else {
          openDialog(context, message: '아이디 혹은 비밀번호가 일치하지 않습니다.',
              onConfirmed: () {
            loginPassword.clear();
          }, type: MessagePopupType.information);
        }
        break;
      case 'signup':
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false);
          openDialog(context, message: "회원가입 성공", onConfirmed: () {
            context.go('/login');
          });
        } else {
          final message = data['resultCode'] == '500'
              ? data['resultCode'] ?? '회원가입 실패'
              : '시스템 에러입니다 \n 관리자에게 문의바랍니다.';
          state = state.copyWith(isLoading: false, errorMessage: message);
          print("회원가입 실패 $message");
          openDialog(context, message: '회원가입 실패', onConfirmed: () {
            return;
          }, type: MessagePopupType.error);
        }
      default:
        print('Unknown requestId: $requestId');
        state = state.copyWith(isLoading: false, errorMessage: '잘못된 요청');
        openDialog(context, message: "잘못된 요청 입니다", onConfirmed: () {
          return;
        }, type: MessagePopupType.warning);
    }
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
    loginUsername.dispose();
    loginPassword.dispose();
    signupName.dispose();
    signupEmail.dispose();
    signupPassword.dispose();
    signupCheckpassword.dispose();
    signupNameFocus.dispose();
    signupEmailFocus.dispose();
    signupPasswordFocus.dispose();
    signupCheckPasswordFocus.dispose();

  }
}

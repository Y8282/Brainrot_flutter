import 'package:brainrot_flutter/common/CommonDialog.dart';
import 'package:brainrot_flutter/login/model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Signupview extends ConsumerWidget {
  const Signupview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initialize();
    });
    final vm = ref.watch(loginViewModelProvider.notifier);
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: vm.SignupName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '이름'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: vm.SignupEmail,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '이메일'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: vm.SignupPassword,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '패스워드'),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: vm.SignupCheckpassword,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '패스워드 확인'),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    vm.signup(context);
                  },
                  child: Text("회원가입")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    openDialog(
                      context,
                      message: "삭제하나요?",
                      buttonType: MessageBottomButtonType.yesno,
                      type: MessagePopupType.warning,
                      onConfirmed: () {
                        context.go('/login');
                      },
                    );
                  },
                  child: Text("홈으로")),
            ],
          ),
        ),
      ),
    );
  }
}

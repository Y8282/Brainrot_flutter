import 'package:brainrot_flutter/login/model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Loginview extends ConsumerWidget {
  Loginview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initialize();
    });
    final loginState = ref.watch(loginViewModelProvider);
    final vm = ref.watch(loginViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 600,
            height: 500,
            child: Column(
              children: [
                TextField(
                  controller: vm.loginUsername,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Username'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: vm.loginPassword,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: loginState.isLoading
                      ? null
                      : () {
                          ref.read(loginViewModelProvider.notifier).login(
                                vm.loginUsername.text,
                                vm.loginPassword.text,
                                context,
                              );
                        },
                  child: loginState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text("회원가입"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => context.go('/findId'),
                      child: Text("아이디 찾기"),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/findPassword'),
                      child: Text("비밀번호 찾기"),
                    )
                  ],
                ),
                if (loginState.errorMessage != null)
                  Text(
                    loginState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

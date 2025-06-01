import 'package:brainrot_flutter/login/views/settingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupViewModel extends StateNotifier<Settingview> {
  final Ref _ref;

  // Editing
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController checkPassword = TextEditingController();

  SignupViewModel(this._ref) : super(const Settingview()) {}

  Future<void> checkedPassword() async {
    if (password != checkPassword) return;

    if (password.text != checkPassword.text) {}
  }
}

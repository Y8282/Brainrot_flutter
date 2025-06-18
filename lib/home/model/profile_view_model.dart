import 'package:brainrot_flutter/login/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final ProfileViewModelProvider = AutoDisposeChangeNotifierProvider<ProfileViewModel>((ref){
  return ProfileViewModel(ref);
});


final userProvider = StateProvider<UserModel?>((ref) {
  return UserModel(username: '', email: '');
});

class ProfileViewModel extends ChangeNotifier{
  final Ref _ref;

    ProfileViewModel(this._ref)  {
    
  }


 

}
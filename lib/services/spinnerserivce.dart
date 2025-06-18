import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final spinnerProvider = ChangeNotifierProvider<Spinnerservice>((ref){
  return Spinnerservice.instance;
});


class Spinnerservice extends ChangeNotifier{
  static final Spinnerservice instance = Spinnerservice._internal();
  factory Spinnerservice() =>instance;
  Spinnerservice._internal();

  bool _isLoading =false;

  bool get isLoading => _isLoading;

  void show(){
    _isLoading =true;
    notifyListeners();
  }

  void hide(){
    _isLoading=false;
    notifyListeners();
  }

}
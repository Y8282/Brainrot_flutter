import 'package:flutter/material.dart';

class NaviState {
  static GlobalKey<NavigatorState> naviagatorState = GlobalKey<NavigatorState>();
  //static NavigatorState get navigatorState => naviagatorState.currentState!;
}

class Api{
 static String baseUrl = 'http://localhost:8080';
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NaviState {
  static GlobalKey<NavigatorState> naviagatorState = GlobalKey<NavigatorState>();
  //static NavigatorState get navigatorState => naviagatorState.currentState!;
}

class Api{
 static String baseUrl = dotenv.env['API_BASE_URL']!;
}
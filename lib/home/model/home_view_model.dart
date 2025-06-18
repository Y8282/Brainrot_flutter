import 'package:brainrot_flutter/home/json/postmodel.dart';
import 'package:brainrot_flutter/home/views/mainView.dart';
import 'package:brainrot_flutter/home/views/makeImageView.dart';
import 'package:brainrot_flutter/home/views/profileView.dart';
import 'package:brainrot_flutter/home/views/searchView.dart';
import 'package:brainrot_flutter/login/views/loginView.dart';
import 'package:brainrot_flutter/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  final bool isLoading;
  final String? imageUrl;
  final String? errorMessage;
  const HomeViewState({
    this.isLoading = false,
    this.imageUrl,
    this.errorMessage,
  });

  HomeViewState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? errorMessage,
  }) {
    return HomeViewState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeViewState>((ref) {
  return HomeViewModel(ref);
});

class HomeViewModel extends StateNotifier<HomeViewState> {
  final Ref _ref;

  // BottomNavigaton
  final PageController pageController = PageController();
  int currentIndex = 0;

  // Page
  final List<Widget> pages = [
    Mainview(),
    Searchview(),
    Makeimageview(),
    Loginview(),
    Profileview(),
  ];

  HomeViewModel(this._ref) : super(const HomeViewState()) {
    initialize();
  }

  void initialize() {
    state = const HomeViewState(
        isLoading: false, imageUrl: null, errorMessage: null);
  }

  // BottomNavigation 탭
  void onItemTapped(int index) {
    if (currentIndex != index) {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

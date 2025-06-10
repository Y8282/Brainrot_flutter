import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  final bool isLoading;
  final String? imageUrl;
  final String? errorMessage;

  const HomeViewState({
    this.isLoading = false,
    this.imageUrl,
    this.errorMessage
  });

  HomeViewState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? errorMessage,
  }) {
    return HomeViewState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}

final homeViewModelProvider = 
    StateNotifierProvider<HomeViewModel , HomeViewState>((ref){
      return HomeViewModel(ref);
    });


class HomeViewModel extends StateNotifier<HomeViewState>{
  final Ref _ref;

  HomeViewModel(this._ref) : super(const HomeViewState()){
    initialize();
  }

  void initialize(){
    state = const HomeViewState(
      isLoading: false , imageUrl: null , errorMessage: null
    );
  }

}
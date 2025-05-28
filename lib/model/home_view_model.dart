import 'package:brainrot_flutter/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'home_view_state.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeViewState>((ref) {
  return HomeViewModel(ref);
});

class HomeViewModel extends StateNotifier<HomeViewState> {
  final Ref _ref;

  HomeViewModel(this._ref) : super(const HomeViewState()) {
    initialize();
  }

  void initialize() {
    state = const HomeViewState(
      isLoading: false,
      imageUrl: null,
      errorMessage: null,
    );
  }

  Future<void> generateImage(String searchTerm, BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final requestId = const Uuid().v4();
    final parameters = {'searchTerm': searchTerm};

    await _ref.read(imageServiceProvider).generateImage(
      parameters: parameters,
      requestId: requestId,
      callback: (status, data, reqId, _) {
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false, imageUrl: data['imageUrl']);
        } else {
          final message = data['resultCode'] == '500'
              ? data['resultMessage']
              : '시스템 에러입니다.\n관리자에게 문의 바랍니다.';
          state = state.copyWith(
            isLoading: false,
            errorMessage: message,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    );
  }
}
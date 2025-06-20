import 'package:brainrot_flutter/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class MakeImageViewState {
  final bool isLoading;
  final String? imageUrl;
  final String? errorMessage;

  const MakeImageViewState({
    this.isLoading = false,
    this.imageUrl,
    this.errorMessage,
  });

  MakeImageViewState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? errorMessage,
  }) {
    return MakeImageViewState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final imageViewModelProvider =
    StateNotifierProvider<ImageViewModel, MakeImageViewState>((ref) {
  return ImageViewModel(ref);
});

class ImageViewModel extends StateNotifier<MakeImageViewState> {
  final Ref _ref;

  // Editing
  final TextEditingController head = TextEditingController(); // 이미지 만들 부품중 머리
  final TextEditingController body = TextEditingController(); // 이미지 만들 부품중 몸
  final TextEditingController arm = TextEditingController(); // 이미지 만들 부품중 팔
  final TextEditingController legs = TextEditingController(); // 이미지 만들 부품중 다리
  final TextEditingController tail = TextEditingController(); // 이미지 만들 부품중 꼬리

  ImageViewModel(this._ref) : super(const MakeImageViewState()) {
    initialize();
  }

  void initialize() {
    state = const MakeImageViewState(
        isLoading: false, imageUrl: null, errorMessage: null);
    head.text = '';
    body.text = '';
    arm.text = '';
    legs.text = '';
    tail.text = '';
  }

  // 이미지 생성 요청
  Future<void> generateImage(String head, String body, String arm, String legs,
      String tail, BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final parameters = {
      'head': head,
      'body': body,
      'arm': arm,
      'legs': legs,
      'tail': tail,
    };
    final requestId = const Uuid().v4();
    await _ref.read(imageServiceProvider).generateImage(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, reqId, _) =>
              handleCallback(status, data, reqId, context),
        );
  }

  // 콜백 처리
  void handleCallback(
      String status, dynamic data, String requestId, BuildContext? context) {
    switch (requestId) {
      case 'generateImage':
        if (status == 'COMPLETED' && data['resultCode'] == '000') {
          state = state.copyWith(isLoading: false, imageUrl: data['imageUrl']);
        } else {
          final message = data['resultCode'] == '500'
              ? data['resultMessage']
              : '시스템 에러입니다.\n관리자에게 문의 바랍니다.';
          state = state.copyWith(isLoading: false, errorMessage: message);
          if (context != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        }
        break;
    }
  }
}

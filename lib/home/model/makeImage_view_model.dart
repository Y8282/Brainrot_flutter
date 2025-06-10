// import 'package:brainrot_flutter/services/image_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';

// class MakeImageViewState {
//   final bool isLoading;
//   final String? imageUrl;
//   final String? errorMessage;

//   const MakeImageViewState({
//     this.isLoading = false,
//     this.imageUrl,
//     this.errorMessage,
//   });

//   MakeImageViewState copyWith({
//     bool? isLoading,
//     String? imageUrl,
//     String? errorMessage,
//   }) {
//     return MakeImageViewState(
//       isLoading: isLoading ?? this.isLoading,
//       imageUrl: imageUrl ?? this.imageUrl,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }

// final homeViewModelProvider =
//     StateNotifierProvider<HomeViewModel, MakeImageViewState>((ref) {
//   return HomeViewModel(ref);
// });

// class HomeViewModel extends StateNotifier<MakeImageViewState> {
//   final Ref _ref;

//   HomeViewModel(this._ref) : super(const MakeImageViewState()) {
//     initialize();
//   }

//   void initialize() {
//     state = const MakeImageViewState(
//         isLoading: false, imageUrl: null, errorMessage: null);
//   }

//   // 이미지 생성 요청
//   Future<void> generateImage(String searchTerm, BuildContext context) async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     final requestId = const Uuid().v4();
//     await _ref.read(imageServiceProvider).generateImage(
//       parameters: {'searchTerm': searchTerm},
//       requestId: requestId,
//       callback: (status, data, reqId, _) =>
//           handleCallback(status, data, reqId, context),
//     );
//   }

//   // 콜백 처리
//   void handleCallback(
//       String status, dynamic data, String requestId, BuildContext? context) {
//     switch (requestId) {
//       case 'generateImage':
//         if (status == 'COMPLETED' && data['resultCode'] == '000') {
//           state = state.copyWith(isLoading: false, imageUrl: data['imageUrl']);
//         } else {
//           final message = data['resultCode'] == '500'
//               ? data['resultMessage']
//               : '시스템 에러입니다.\n관리자에게 문의 바랍니다.';
//           state = state.copyWith(isLoading: false, errorMessage: message);
//           if (context != null) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(message)));
//           }
//         }
//         break;
//     }
//   }
// }

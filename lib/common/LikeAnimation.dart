// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final likeFunctionProvider = ChangeNotifierProvider<LikeFunction>((ref) {
//   return LikeFunction();
// },);
// class LikeAnimation extends ConsumerWidget{
//   const LikeAnimation({super.key});

// @override
// Widget build(BuildContext context , WidgetRef ref) {
//   final likeState = ref.watch(likeFunctionProvider);
//   return Scaffold(
//     body: ,
//   );
//   }

// }



// class LikeFunction extends ChangeNotifier {
//   bool _isShowHeart = false;
//   bool _isHeart = false;

//   bool get isShowHeart => _isShowHeart;
//   bool get isHeart => _isHeart;

//   void onDoubleTap(){
//     _isShowHeart=true;
//     _isHeart = true;
//     notifyListeners();

//     Future.delayed(const Duration(milliseconds: 500),(){
//       _isShowHeart=false;
//       notifyListeners();
//     });
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
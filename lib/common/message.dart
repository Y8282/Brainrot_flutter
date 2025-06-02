// import 'package:flutter/material.dart';

// class CustomAlertDialog extends StatelessWidget {
//   final String? content;
//   final Function? function;
//   const CustomAlertDialog({
//     this.content,
//     this.function,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 8,
//       child: Container(
//         width: 200,
//         height: 100,
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               content ?? '알림',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[300],
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   ),
//                   onPressed: () => Navigator.pop(context, '취소'),
//                   child: Text('닫기'),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context, '확인');
//                     if (function != null) function!();
//                   },
//                   child: Text('확인'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showDiaLog(BuildContext context,
//     {String? content, Function? onConfirm}) async {
//   final result = await showDialog<String>(
//     context: context,
//     builder: (context) =>
//         CustomAlertDialog(content: content, function: onConfirm),
//   );

//   if (result != null) {
//     print('선택된 값: $result');
//   }
// }

// class CustomConfirmDialog extends StatelessWidget {
//   final String? content;
//   final Function? onConfirm;

//   const CustomConfirmDialog({
//     this.content,
//     this.onConfirm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 8,
//       child: Container(
//         width: 300,
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               content ?? '알림',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//               ),
//               onPressed: () {
//                 Navigator.pop(context, '확인');
//                 if (onConfirm != null) onConfirm!();
//               },
//               child: Text('확인'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showConfirmDialog(BuildContext context,
//     {String? content, Function? onConfirm}) async {
//   final result = await showDialog<String>(
//     context: context,
//     builder: (context) =>
//         CustomConfirmDialog(content: content, onConfirm: onConfirm),
//   );

//   if (result != null) {
//     print('사용자 응답: $result');
//   }
// }

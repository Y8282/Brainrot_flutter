import 'package:brainrot_flutter/common/color.dart';
import 'package:flutter/material.dart';

class Custombottomsheet extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget? child;
  final VoidCallback buttonClick;
  final VoidCallback onSubmitted;

  const Custombottomsheet(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.buttonClick,
      required this.onSubmitted,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height , 
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.whiteGray,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const Center(child: Icon(Icons.drag_handle)),
          const SizedBox(height: 3),
          Text(
            "댓글",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Divider(
            height: 1,
            color: ColorStyles.gray,
          ),
          const SizedBox(height: 16),
          if (child != null)
            Container(
              child: child!,
            ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: buttonClick,
                icon: Icon(Icons.search),
              ),
              border: OutlineInputBorder(),
              labelText: "댓글 입력하기",
            ),
            onSubmitted: (_) => onSubmitted(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Commonbutton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Icon? icon;
  final Color? backgroundColor;
  final double? size;
  final Color foregroundColor = Colors.black;

  const Commonbutton(
      {this.text,
      this.icon,
      this.backgroundColor,
      this.size,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, foregroundColor: foregroundColor),
      onPressed: onPressed,
      child: icon ?? 
           Text(
              text ?? '',
              style: TextStyle(fontSize: size),
            ),
    );
  }
}

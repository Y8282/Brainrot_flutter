import 'package:flutter/material.dart';

class Loadingview extends StatelessWidget {
  const Loadingview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
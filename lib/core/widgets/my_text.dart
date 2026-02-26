import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  const MyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        letterSpacing: 0.05,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2B4464),
      ),
    );
  }
}

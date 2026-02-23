import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool colored;
  const MyButton({
    super.key,
    required this.text,
    this.onTap,
    this.colored = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: colored ? Color(0xFF2B4464) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: colored
              ? null
              : Border.all(color: Color(0xFF2B4464), width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: colored ? Colors.white : Color(0xFF2B4464),
            ),
          ),
        ),
      ),
    );
  }
}

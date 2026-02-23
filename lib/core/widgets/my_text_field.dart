import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  final bool eye;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.eye = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isObscure = false;
  bool eye = false;

  @override
  void initState() {
    isObscure = widget.isObscure;
    eye = widget.eye;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: widget.hintText,
        suffixIcon: eye
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
              )
            : null,
      ),
      obscureText: isObscure,
    );
  }
}

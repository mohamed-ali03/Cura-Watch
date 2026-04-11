import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  final bool eye;
  final bool isNumber;
  final int numberOfRows;
  final Color? color;
  final bool isEditable;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.eye = false,
    this.isNumber = false,
    this.numberOfRows = 1,
    this.color,
    this.isEditable = true,
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
      obscureText: isObscure,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: widget.isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      maxLines: widget.numberOfRows,
      enabled: widget.isEditable,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.color),
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
    );
  }
}

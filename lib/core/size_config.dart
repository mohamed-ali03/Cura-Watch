import 'package:flutter/material.dart';

class SizeConfig {
  late double screenHight;
  late double screenWidth;

  late double blockHight;
  late double blockWidth;

  void init(BuildContext context) {
    final size = MediaQuery.of(context).size;

    screenHight = size.height;
    screenWidth = size.width;

    blockHight = screenHight / 100;
    blockWidth = screenWidth / 100;
  }
}

import 'package:flutter/material.dart';

class Sizes {
  late Size screenSize;
  late double height, width;

  Sizes(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    height = screenSize.height;
    width = screenSize.width;
  }

  late double h20 = height * 0.20;

  late double h2 = height * 0.02;

  late double w1 = width * 0.01;

  late double w3 = width * 0.03;
}

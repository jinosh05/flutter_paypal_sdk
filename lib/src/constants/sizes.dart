import 'package:flutter/material.dart';

class Sizes {
  late Size screenSize;
  late double height, width;

  Sizes(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    height = screenSize.height;
    width = screenSize.width;
  }

  late double h1 = height * 0.01;

  late double h2 = height * 0.02;

  late double h10 = height * 0.10;

  late double h20 = height * 0.20;

  late double w1 = width * 0.01;

  late double w2 = width * 0.02;

  late double w3 = width * 0.03;
}

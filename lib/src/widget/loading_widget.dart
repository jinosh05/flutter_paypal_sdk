import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/sizes.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.s,
    this.radius,
  }) : super(key: key);

  final Sizes s;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        size: radius ?? s.h2,
        color: const Color(0xFFEB920D),
      ),
    );
  }
}

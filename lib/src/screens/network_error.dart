import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/src/constants/constants.dart';
import 'package:flutter_paypal_sdk/src/constants/sizes.dart';

class NetworkErrorScr extends StatelessWidget {
  const NetworkErrorScr(
      {super.key, required this.loadData, required this.message});
  final Function loadData;
  final String message;

  @override
  Widget build(BuildContext context) {
    Sizes s = Sizes(context);
    return Column(
      children: [
        Image.asset(
          Constants.noNetPng,
          height: s.h20,
        ),
        SizedBox(
          height: s.h2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: s.h2,
                color: const Color(0xFF272727),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: s.w1,
            ),
            InkWell(
              onTap: () => loadData(),
              child: Text(
                "Tap to retry",
                style: TextStyle(
                    fontSize: s.h2,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        )
      ],
    );
  }
}

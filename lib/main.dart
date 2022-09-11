import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/src/screens/network_error.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Material App Bar'),
          ),
          body: NetworkErrorScr(loadData: () {}, message: "Load")),
    );
  }
}

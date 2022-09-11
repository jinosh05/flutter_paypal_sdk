import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/src/screens/network_error.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: NetworkErrorScr(loadData: () {}, message: "Load"),
      ),
    );
  }
}

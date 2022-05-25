import 'package:flutter/material.dart';

import 'market/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woo Network Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MarketScreen(),
    );
  }
}

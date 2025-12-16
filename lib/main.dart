import 'package:flutter/material.dart';

void main() {
  runApp(const EvApp());
}

class EvApp extends StatelessWidget {
  const EvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

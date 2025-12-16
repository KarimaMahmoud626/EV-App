import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const EvApp());
}

class EvApp extends StatelessWidget {
  const EvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const ChcApp());
}

class ChcApp extends StatelessWidget {
  const ChcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Central Heating Control',
        home: Scaffold(
            body: Center(
          child: Text('Central Heating Control'),
        )));
  }
}

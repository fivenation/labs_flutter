import 'package:flutter/material.dart';
import 'package:labs_flutter/Vanilla/HomePageVanilla.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: HomePageVanilla() /// HERE YOU CAN CHANGE PATTERN OF STATE ARCHITECTURE
    );
  }
}
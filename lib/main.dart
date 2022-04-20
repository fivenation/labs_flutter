import 'package:flutter/material.dart';
import 'package:labs_flutter/ScopedModelArchitecture.dart';
import 'package:labs_flutter/VanillaArchitecture.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

        /// HERE YOU CAN CHANGE EXAMPLE
      //home: HomePageVanilla()
      home: HomePageScopedModel()
    );
  }
}
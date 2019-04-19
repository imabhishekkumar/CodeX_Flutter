import 'package:code_x/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "CodeX",
        debugShowCheckedModeBanner: false,
        /*theme: ThemeData(
          primarySwatch: Colors.grey,
        ),*/
        home: Home());
  }
}

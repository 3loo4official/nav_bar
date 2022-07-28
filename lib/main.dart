import 'package:flutter/material.dart';
import 'package:nav_bar/layouts/home_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {



   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayoutState(),
    );
  }
}

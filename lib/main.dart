import 'package:flutter/material.dart';
import 'package:eargori/views/HomeScreen.dart';
import 'views/LoginScreen.dart';

void main() {
  runApp(const Eargori());
}

class Eargori extends StatelessWidget {
  const Eargori({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eargori',
        theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'SF Pro Text',
        ),
        home: HomeScreen());
  }
}

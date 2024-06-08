import 'package:eargori/controllers/MainController.dart';
import 'package:eargori/views/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Eargori());
}

class Eargori extends StatelessWidget {
  const Eargori({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eargori',
        theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'SF Pro Text',
        ),
        home: LoginScreen(),
      ),
    );
  }
}

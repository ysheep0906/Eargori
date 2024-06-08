import 'package:flutter/material.dart';

class ShowText extends StatelessWidget {
  final String text;

  const ShowText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 200,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

import 'package:eargori/views/LoginScreen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const registerUrl = '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTitleText('아이디'),
            buildTextField(),
            buildTitleText('비밀번호'),
            buildTextField(obscureText: true),
            buildTitleText('비밀번호 확인'),
            buildTextField(obscureText: true),
            buildTitleText('넥네임'),
            buildTextField(),
            buildRegisterButton(context, '회원가입'),
          ],
        ),
      ),
    );
  }
}

Container buildRegisterButton(BuildContext context, String text) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          offset: const Offset(0, 4),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    ),
    child: OutlinedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xffDEEDFF),
          fixedSize: const Size(283, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Text(text,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              letterSpacing: 10,
            ))),
  );
}

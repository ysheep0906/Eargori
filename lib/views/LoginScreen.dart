import 'package:eargori/views/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:eargori/views/RegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  static const loginUrl = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildLogo(),
            buildTitleText('아이디'),
            buildTextField(),
            buildTitleText('비밀번호'),
            buildTextField(obscureText: true),
            buildLoginButton(context, '로그인'),
            buildToRegisterButton(context, '회원가입'),
          ],
        ),
      ),
    );
  }
}

Widget buildTitleText(String title) {
  return Container(
      width: 283,
      child: Text(title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )));
}

Widget buildLogo() {
  return Image.asset(
    'assets/logo.png',
    width: 150,
    height: 249.26,
  );
}

Widget buildTextField({bool obscureText = false}) {
  return Container(
    width: 283,
    height: 65,
    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
    margin: const EdgeInsets.only(bottom: 35),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          offset: const Offset(0, 4),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xff969696)),
    ),
    child: TextField(
      obscureText: obscureText,
      decoration: InputDecoration(border: InputBorder.none),
    ),
  );
}

Container buildLoginButton(BuildContext context, String text) {
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
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

Widget buildToRegisterButton(BuildContext context, String text) {
  return Container(
    alignment: Alignment.center,
    width: 283,
    margin: const EdgeInsets.only(top: 20),
    child: TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()));
      },
      child: Text(text,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 20,
            fontWeight: FontWeight.w200,
          )),
    ), //text로 버튼 만들기
  );
}

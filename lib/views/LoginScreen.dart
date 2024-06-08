import 'dart:convert';

import 'package:eargori/controllers/MainController.dart';
import 'package:eargori/services/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:eargori/views/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  String errMsg = '';

  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final storage = FlutterSecureStorage();

    try {
      final response = await _loginService.login(username, password);
      if (response != null) {
        print('Login successful: $response');
        // if (UniversalPlatform.isWeb) {
        //   window.localStorage['jwt_token'] = response['token'];
        // } else {
        // 모바일 및 데스크톱에서 저장
        await storage.write(key: 'jwt_token', value: response['user']['token']);
        // }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainController()));
      }
    } catch (e) {
      setState(() {
        errMsg = e.toString().replaceAll('Exception: ', '');
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eargori',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'SF Pro Text',
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLogo(),
                  buildTitleText('아이디'),
                  buildIDTextField(),
                  buildTitleText('비밀번호'),
                  buildPWTextField(),
                  buildText(),
                  buildLoginButton(context, '로그인'),
                  buildToRegisterButton(context, '회원가입'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Text(errMsg, style: const TextStyle(color: Colors.red));
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

  Widget buildIDTextField() {
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
        controller: _usernameController,
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget buildPWTextField() {
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
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget buildLogo() {
    return Image.asset(
      'assets/logo.png',
      width: 150,
      height: 249.26,
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
            _login(context);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const MainController()));
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
}

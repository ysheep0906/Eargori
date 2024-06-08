import 'package:eargori/views/LoginScreen.dart';
import 'package:eargori/services/RegisterService.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final RegisterService _registerService = RegisterService();
  String errMsg = '';
  bool flagPWcheck = false;

  Future<void> _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final nickname = _nicknameController.text;

    try {
      final response =
          await _registerService.register(username, password, nickname);
      if (response != null) {
        print('Register successful: $response');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      setState(() {
        errMsg = e.toString().replaceAll('Exception: ', '');
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
                  buildTitleText('아이디'),
                  buildIDTextField(),
                  buildTitleText('비밀번호'),
                  buildPWTextField(),
                  buildTitleText('비밀번호 확인'),
                  buildPWCheckTextField(true),
                  buildTitleText('닉네임'),
                  buildNickTextField(),
                  buildText(),
                  buildRegisterButton(context, '회원가입'),
                  buildToLoginButton(context, '로그인')
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
    return SizedBox(
        width: 283,
        child: Text(title,
            style: const TextStyle(
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
        decoration: const InputDecoration(border: InputBorder.none),
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
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget buildPWCheckTextField(bool isConfirmPassword) {
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
        controller: isConfirmPassword
            ? _confirmPasswordController
            : _passwordController,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (isConfirmPassword) {
            if (value != _passwordController.text) {
              setState(() {
                errMsg = '비밀번호가 일치하지 않습니다.';
                flagPWcheck = false;
              });
            } else {
              setState(() {
                errMsg = '';
                flagPWcheck = true;
              });
            }
          }
        },
      ),
    );
  }

  Widget buildNickTextField() {
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
        controller: _nicknameController,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
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
            if (flagPWcheck) {
              _register();
            }
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

  Widget buildToLoginButton(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      width: 283,
      margin: const EdgeInsets.only(top: 20),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
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

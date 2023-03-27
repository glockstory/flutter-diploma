import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final String logoImage = 'assets/logo.png';
  final TextStyle logoText = const TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600);
  final TextStyle simpleText = const TextStyle(
      color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w400);
  final TextStyle linkStyle = const TextStyle(
      color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.w400);
  final ButtonStyle styleButton = ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)));
  final TextStyle buttonText = const TextStyle(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(logoImage),
          SizedBox(
            height: 20.0,
          ),
          Text('Войти в Routine Support', style: logoText),
          SizedBox(height: 15.0),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 5.0))),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 5.0))),
          ),
          SizedBox(height: 10.0),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Еще не зарегистрированы? ', style: simpleText),
            TextSpan(
                text: 'Создать аккаунт',
                style: linkStyle,
                recognizer: TapGestureRecognizer()..onTap = () => () {})
          ])),
          SizedBox(height: 10.0),
          ElevatedButton(
              onPressed: () {},
              child: Text('Войти', style: buttonText),
              style: styleButton),
        ]),
      ),
    );
  }
}

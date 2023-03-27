import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter_final/styles/textstyle.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  final String logoImage = 'assets/logo.png';

  final ButtonStyle styleButton = ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)));

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
          Text('Зарегистрироваться в Routine Support',
              style: logoText, textAlign: TextAlign.center),
          SizedBox(height: 15.0),
          TextField(
              controller: _emailController,
              decoration:
                  InputDecoration(hintText: 'Email', border: borderTextField)),
          SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            decoration:
                InputDecoration(hintText: 'Name', border: borderTextField),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                InputDecoration(hintText: 'Password', border: borderTextField),
          ),
          SizedBox(height: 10.0),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'Уже зарегистрированы? ', style: simpleText),
            TextSpan(
                text: 'Войти',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context);
                  })
          ])),
          SizedBox(height: 10.0),
          ElevatedButton(
              onPressed: () {},
              child: Text('Зарегистрироваться', style: buttonText),
              style: styleButton),
        ]),
      ),
    );
  }
}

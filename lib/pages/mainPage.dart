import 'package:flutter/material.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter/gestures.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
          Text('Войти в Routine Support', style: logoText),
          SizedBox(height: 15.0),
          TextField(
            controller: _emailController,
            decoration:
                InputDecoration(hintText: 'Email', border: borderTextField),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Password',
              border: borderTextField,
            ),
          ),
          SizedBox(height: 10.0),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'Еще не зарегистрированы? ', style: simpleText),
            TextSpan(
                text: 'Создать аккаунт',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  })
          ])),
          SizedBox(height: 10.0),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
              child: Text('Войти', style: buttonText),
              style: styleButton),
        ]),
      ),
    );
  }
}

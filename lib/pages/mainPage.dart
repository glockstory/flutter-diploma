import 'package:flutter/material.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_final/widgets/button.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePass = false;

  final _formKey = GlobalKey<FormState>();
  final String logoImage = 'assets/logo.png';

  final ButtonStyle styleButton = ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)));

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле должно быть заполнено';
                  }
                  if (!validateEmail(value)) {
                    return 'Некорректный email';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: borderTextField,
                  // errorText:
                  //     _validateEmail ? null : 'Поле дожно быть заполнено',
                  // errorBorder: _validateEmail
                  //     ? OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.red),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       )
                  //     : null,
                  // focusedErrorBorder: _validateEmail
                  //     ? OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.red),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       )
                  //     : null,
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле должно быть заполнено';
                  }
                  if (!validatePassword(value)) {
                    return 'Пароль должен быть не меньше 3 символов';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: borderTextField,
                ),
              ),
            ]),
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
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => CalendarPage()));
          //     },
          //     child: Text('Войти', style: buttonText),
          //     style: styleButton),
          MyButton(
              label: 'Войти',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  debugPrint('Success');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CalendarPage()));
                }
                // setState(() {
                //   _validateEmail = _emailController.text.isEmpty ? true : false;
                //   _validatePass =
                //       _passwordController.text.isEmpty ? true : false;
                //   if (_validateEmail == false && _validatePass == false) {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => CalendarPage()));
                //   }
                // });
              })
        ]),
      ),
    );
  }
}

bool validateEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  return password.length >= 3;
}

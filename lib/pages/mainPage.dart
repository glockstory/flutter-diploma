import 'package:flutter/material.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //Контроллер почты
  TextEditingController _emailController = TextEditingController();
  //Контроллер пароля
  TextEditingController _passwordController = TextEditingController();
  //Успешна ли валидация почты
  bool _validateEmail = false;
  //Успешна ли валидация пароля
  bool _validatePass = false;

  //Глобальный ключ для использования валидации
  final _formKey = GlobalKey<FormState>();
  //Путь к лого
  final String logoImage = 'assets/logo.png';
  //Стиль для кнопки
  final ButtonStyle styleButton = ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)));
  //Функция авторизации
  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      final Uri uri = Uri.parse('http://10.0.2.2:3000/signin');

      print(_emailController.text);
      print(_passwordController.text);

      final response = await http.post(
        uri,
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      print(response.body);
      print(response.statusCode);

      // If the request is successful, return the user object
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final userId = body['user']['_id'];
        print(userId);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        print('OK');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      } else {
        throw Exception('Failed to login');
      }
    }
  }

  //Очистка контроллеров при выходе из страницы
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
          MyButton(
            label: 'Войти',
            onTap: _submit,
          )
        ]),
      ),
    );
  }
}

//Функция валидации почты
bool validateEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

//Функция валидации пароля
bool validatePassword(String password) {
  return password.length >= 3;
}

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Контроллеры соответствующих полей
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  //Глобальный ключ для валидации полей
  final _formKey = GlobalKey<FormState>();

  //Функция регистрации пользователя(запрос на сервер)
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final Uri uri = Uri.parse('http://10.0.2.2:3000/register');
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          }));
          
      print(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User created')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating user')),
        );
      }
    }
  }

  //Ссылка на картинку лого
  final String logoImage = 'assets/logo.png';
  //Стиль кнопки
  final ButtonStyle styleButton = ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)));
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(logoImage),
              SizedBox(
                height: 20.0,
              ),
              Text('Зарегистрироваться в Routine Support',
                  style: logoText, textAlign: TextAlign.center),
              SizedBox(height: 15.0),
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
                      hintText: 'Email', border: borderTextField)),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле должно быть заполнено';
                  }
                },
                decoration:
                    InputDecoration(hintText: 'Name', border: borderTextField),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле должно быть заполнено';
                  }
                  if (!validatePassword(value)) {
                    return 'Пароль должен быть не меньше 3 символов';
                  }
                },
                autocorrect: false,
                decoration: InputDecoration(
                    hintText: 'Password', border: borderTextField),
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
              MyButton(
                label: 'Зарегистрироваться',
                onTap: _submit,
              )
            ]),
          ),
        ));
  }
}

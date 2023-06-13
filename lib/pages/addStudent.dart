import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_final/pages/students.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  //Контроллер соответствующего поля
  final TextEditingController _nameController = TextEditingController();

  //Функция создания студента (запрос на сервер)
  Future<void> createStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    mongo.ObjectId coachId = mongo.ObjectId.parse(userId!);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/students/create');

    final response = await http.post(
      uri,
      body: jsonEncode(
        <String, dynamic>{
          'name': _nameController.text,
          'coachId': userId,
          'color': '#FFFFF'
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    print(response.statusCode);
    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to create student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание студента'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              const Text(
                'Имя',
                style: simpleText,
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: 'Введите имя', border: borderTextField)),
            ],
          )),
      floatingActionButton: MyButton(
          label: '+ Создать',
          onTap: () {
            createStudent();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StudentsPage()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

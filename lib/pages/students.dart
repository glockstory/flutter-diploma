import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_final/models/student.dart';
import 'package:flutter_final/pages/addStudent.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:flutter_final/widgets/studentCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  //Список студентов
  List<Student> students = [];
  
  //Функция получения списка студентов ЛИО (запрос на сервер)
  Future<List<Student>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print(userId);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/students/$userId');
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List<dynamic> studentJson = json.decode(response.body);
      students = studentJson.map((json) => Student.fromJson(json)).toList();
      print(students);
      print(students.length);
      
      return students;

    } else {
      throw Exception('Failed to load records');
    }
  }

  @override
  void initState() {
    super.initState();
    // вызов функции при запуске экрана
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Дети'),
      ),
      drawer: Drawer(
          child: SafeArea(
              child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text('Календарь'),
            leading: Icon(Icons.calendar_month_rounded),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarPage()));
            },
          ),
          ListTile(
            dense: true,
            title: Text('Дети'),
            leading: Icon(Icons.people_rounded),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            title: Text('Выйти'),
            leading: Icon(Icons.logout_rounded),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          )
        ],
      ))),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<List<Student>>(
        future: getStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  child: StudentCardWidget(student: snapshot.data![index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: MyButton(
          label: '+ Студент',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddStudent()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

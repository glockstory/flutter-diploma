import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_final/models/student.dart';
import 'package:flutter_final/pages/addActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_final/styles/textstyle.dart';

class StudentPickerWidget extends StatefulWidget {
  const StudentPickerWidget({super.key});

  @override
  State<StudentPickerWidget> createState() => _StudentPickerWidgetState();
}

class _StudentPickerWidgetState extends State<StudentPickerWidget> {
  List<Student> students = [];
  List selectedStudents = [];
  Color buttonColor = Colors.grey;
  List<bool> _buttonStates = [];

  Future<List<Student>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final Uri uri = Uri.parse('http://10.0.2.2:3000/students/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> studentJson = json.decode(response.body);
      students = studentJson.map((json) => Student.fromJson(json)).toList();

      setState(() {
        _buttonStates = List.filled(students.length, false);
      });
      return students;
    } else {
      throw Exception('Failed to load records');
    }
  }

  @override
  void initState() {
    super.initState();
    getStudents().then((students) {
      setState(() {
        this.students = students;
        _buttonStates = List.filled(students.length, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 5.0,
            children: [
              if (students.isNotEmpty)
                Row(
                  children: students.map((student) {
                    int index = students.indexOf(student);
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_buttonStates[index] == false) {
                            selectedStudents.add(student);
                            _buttonStates[index] = true;
                            AddActivity.selectedStudentsToSend =
                                selectedStudents;
                            print('after add: ${selectedStudents}');
                          } else {
                            selectedStudents.remove(student);
                            _buttonStates[index] = false;
                            print('after delete: ${selectedStudents}');
                            AddActivity.selectedStudentsToSend =
                                selectedStudents;
                          }
                        });
                      },
                      child: Text(student.name),
                      style: ElevatedButton.styleFrom(
                        primary:
                            _buttonStates[index] ? primaryClr : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (students.isEmpty) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

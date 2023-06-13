import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_final/pages/students.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:http/http.dart' as http;

class StudentSettings extends StatefulWidget {
  final String studentId;

  const StudentSettings({super.key, required this.studentId});

  @override
  State<StudentSettings> createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  TextEditingController _controller = TextEditingController();

  Future<void> deleteStudent() async {
    final String id = widget.studentId;
    final Uri uri = Uri.parse('http://10.0.2.2:3000/students/delete/$id');

    final response = await http.delete(uri);

    print(response.statusCode);
    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Failed to delete student');
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you want to delete this student?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                await deleteStudent();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudentsPage()));
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Редактирование студента'),
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
                  'Язык приложения',
                  style: simpleText,
                ),
                SizedBox(
                  height: 8,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text('Select language'),
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Русский', 'English', 'Dutch']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            )),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            child: Icon(Icons.delete),
            onPressed: () {
              _showMyDialog();
            },
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context);
            },
            heroTag: null,
          )
        ]));
  }
}

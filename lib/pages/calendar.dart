import 'package:flutter/material.dart';
import 'package:flutter_final/models/activity.dart';
import 'package:flutter_final/pages/addActivity.dart';
import 'package:flutter_final/pages/students.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:flutter_final/widgets/gridViewWidget.dart';
import 'package:flutter_final/widgets/inputField.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  
  Future<List<dynamic>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print(userId);
    final Uri uri =
        Uri.parse('http://10.0.2.2:3000/activities/6230ceefdf1df472a675c92b');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final activities = jsonDecode(response.body);
      print(activities);
      return activities;
    } else {
      throw Exception('Failed to load records');
    }
    //throw Exception('Failed to load records');
  }

  @override
  void initState() {
    super.initState();
    // вызов функции при запуске экрана
    getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Календарь'),
          //leading: Icon(Icons.menu),
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudentsPage()));
              },
            ),
            ListTile(
              dense: true,
              title: Text('Выйти'),
              leading: Icon(Icons.logout_rounded),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
            )
          ],
        ))),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: SfCalendar(
                view: CalendarView.day,
              ),
            ),
            MyButton(
                label: '+ Создать',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddActivity()));
                }),
          ],
        ));
  }
}

/*
MyButton(
                  label: '+ Создать',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddActivity()));
                  }),
*/
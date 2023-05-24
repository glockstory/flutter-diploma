import 'package:flutter/material.dart';
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

import '../utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<String> timeList = [
    '6:00',
    '7:00',
    '8:00',
    '9:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00'
  ];

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
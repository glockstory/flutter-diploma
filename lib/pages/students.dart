import 'package:flutter/material.dart';
import 'package:flutter_final/pages/addActivity.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/styles/buttonstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:flutter_final/widgets/gridViewWidget.dart';
import 'package:flutter_final/widgets/inputField.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Дети'),
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
              Navigator.pop(context);
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
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              )
            ]),
          )),
    );
  }
}

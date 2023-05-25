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
  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        subject: 'Полить цветы',
        color: Colors.teal,
      ),
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        subject: 'Помыть посуду',
        color: Colors.teal,
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(hours: 4)),
        endTime: DateTime.now().add(Duration(hours: 6)),
        subject: 'Погулять',
        color: Colors.teal,
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        subject: 'Conference',
        color: Colors.blue,
      ),
    ];
    return _AppointmentDataSource(appointments);
  }

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
                dataSource: _getCalendarDataSource(),
                showCurrentTimeIndicator: false,
                onTap: (CalendarTapDetails details) {
                  final appointment = details.appointments?.first;
                  // final startTime = appointment.startTime;

                  print(appointment);
                  // print(startTime);
                  //print('Appointments: $appointments');
                },
                appointmentBuilder: (context, calendarAppointmentDetails) {
                  final appointment =
                      calendarAppointmentDetails.appointments.first;
                  final subject = appointment.subject;
                  return Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(255, 149, 237, 165)),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$subject',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              //Text('1'),
                              SizedBox(width: 4),
                              //Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          print('tapped');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 118, 117, 117),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(4),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('0 / 3',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(width: 4),
                              Icon(Icons.check, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]);
                },
                // appointmentTextStyle: TextStyle(
                //     color: Colors.black,
                //     fontSize: 35,
                //     fontWeight: FontWeight.bold),
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeIntervalHeight: 100,
                  timeInterval: Duration(minutes: 60),
                  //timeFormat: 'HH:mm'
                ),
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
// CalendarDataSource _getCalendarDataSource() {
//   List<Appointment> appointments = <Appointment>[
//     Appointment(
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(Duration(hours: 2)),
//       subject: 'Meetings',
//       color: Colors.teal,
//     ),
//   ];
//   return _AppointmentDataSource(appointments);
// }

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

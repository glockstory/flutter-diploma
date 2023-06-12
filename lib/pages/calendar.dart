import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_final/models/activity.dart';
import 'package:flutter_final/models/student.dart';
import 'package:flutter_final/pages/addActivity.dart';
import 'package:flutter_final/pages/editActivity.dart';
import 'package:flutter_final/pages/notificationPage.dart';
import 'package:flutter_final/pages/students.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:flutter_final/widgets/studentsPicker.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    activities.forEach(
      (activity) {
        List<String> dateParts = activity.date.split('.');
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);
        DateTime date = DateTime(year + 2000, month, day);

        List<String> timeParts = activity.start.split(':');
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);
        DateTime time1 = DateTime(0, 1, 1, hour, minute);

        List<String> timeEndParts = activity.end.split(':');
        int endHour = int.parse(timeEndParts[0]);
        int endMinute = int.parse(timeEndParts[1]);
        DateTime time2 = DateTime(0, 1, 1, endHour, endMinute);

        DateTime timeStart =
            DateTime(date.year, date.month, date.day, time1.hour, time1.minute);
        DateTime timeEnd =
            DateTime(date.year, date.month, date.day, time2.hour, time2.minute);

        appointments.add(Appointment(
          startTime: timeStart,
          endTime: timeEnd,
          subject: activity.name,
          id: activity.id,
        ));
      },
    );
    // List<Activity> activities = activitiesCalendar;
    // print(activities);
    //print(activitiesCalendar);
    return _AppointmentDataSource(appointments);
  }

  List<Activity> activities = [];

  List studentsOnCard = [];
  List exampleStudents = [];
  Future<void> findActivity(activityId) async {
    //final activityId = widget.activityId;
    //print(activityId);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/activity/$activityId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> activitiesJson = json.decode(response.body);
      final activity =
          activitiesJson.map((json) => Activity.fromJson(json)).toList();
      activity.forEach(
        (element) {
          //studentsOnCard.add(element.students);
          element.students.forEach((element) {});
        },
      );
    }
  }

  Future<void> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print(userId);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/students/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> studentJson = json.decode(response.body);
      final students =
          studentJson.map((json) => Student.fromJson(json)).toList();

      studentsOnCard = students;

      //print(students);
      //print(students.length);
    } else {
      throw Exception('Failed to load records');
    }
  }

  Future<List<Activity>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print(userId);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/activities/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      //final activities = jsonDecode(response.body);
      final List<dynamic> activitiesJson = json.decode(response.body);
      activities =
          activitiesJson.map((json) => Activity.fromJson(json)).toList();
      print('lenght of activities: ${activities.length}');
      return activities;
    } else {
      throw Exception('Failed to load records');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Календарь'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()));
                },
                icon: Icon(Icons.notifications))
          ],
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
        body: FutureBuilder<List<Activity>>(
            future: getActivities(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: SfCalendar(
                        view: CalendarView.day,
                        dataSource: _getCalendarDataSource(),
                        showCurrentTimeIndicator: false,
                        onTap: (CalendarTapDetails details) {
                          final appointment = details.appointments?.first;
                          if (appointment != null) {
                            print(appointment);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditActivity(
                                        activityId: appointment.id)));
                          } else {
                            //TODO create activity with start and end time OPTIONAL
                          }
                        },
                        appointmentBuilder:
                            (context, calendarAppointmentDetails) {
                          final appointment =
                              calendarAppointmentDetails.appointments.first;
                          final subject = appointment.subject;
                          return FutureBuilder(
                              future: getStudents(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Stack(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Color.fromARGB(
                                              255, 149, 237, 165)),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${appointment.subject}',
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
                                        onTap: () async {
                                          //show dialog
                                          return await showDialog(
                                              context: context,
                                              builder: (context) {
                                                print(appointment.id);
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  elevation: 8,
                                                  child: Container(
                                                      height: 300,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Ожидаются',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          //ADD STUDENTS
                                                          Container(
                                                            height: 100,
                                                            child: Wrap(
                                                              children:
                                                                  List.generate(
                                                                studentsOnCard
                                                                    .length,
                                                                (index) =>
                                                                    Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        primaryClr,
                                                                    border: Border.all(
                                                                        color:
                                                                            primaryClr),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child: Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child: Text(
                                                                          '${studentsOnCard[index].name}',
                                                                          style:
                                                                              logoText)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Text(
                                                            'Прошли',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          )
                                                        ],
                                                      )),
                                                );
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 118, 117, 117),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  '0 / ${studentsOnCard.length}',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(width: 4),
                                              Icon(Icons.check,
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                                }
                              });
                        },
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddActivity()));
                        }),
                  ],
                );
              }
            }));
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

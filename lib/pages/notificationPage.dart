import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_final/models/notification.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:collection/collection.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notifications> notifications = [];
  List grouped = [];
  Future<List<Notifications>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print(userId);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/notifications/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> notif = jsonDecode(response.body);
      print(notif);
      notifications =
          notif.map((json) => Notifications.fromJson(json)).toList();
      print(notifications);

      notifications.forEach((element) {
        List<String> dateParts = element.date.split('.');
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);
        DateTime date = DateTime(year + 2000, month, day);
        print(date);
      });

      return notifications;
      // final List<dynamic> activitiesJson = json.decode(response.body);
      // notifications =
      //     activitiesJson.map((json) => Notification.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load records');
    }
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<Notifications>>(
        future: getNotifications(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else {
            notifications = snapshot.data!;
            final groupedNotifications = notifications.groupListsBy(
              (notification) => notification.date,
            );
            return ListView.builder(
                itemCount: groupedNotifications.length,
                itemBuilder: (BuildContext context, index) {
                  final date = groupedNotifications.keys.toList()[index];
                  final notificationsForDate = groupedNotifications[date];
                  print("DATE: $notificationsForDate");
                  notificationsForDate?.forEach(
                    (element) {
                      print(element.name);
                    },
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 20, bottom: 5),
                        child: Text(
                          date.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      ListView.builder(
                          itemCount: notificationsForDate?.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, bottom: 10),
                                  child: Text(
                                    '${notificationsForDate?[index].name}',
                                    style: logoText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text(
                                    '${notifications[index].timeStart} - ${notifications[index].timeEnd}',
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20, left: 20),
                                  child: Divider(
                                    height: 10,
                                  ),
                                ),
                              ],
                            );
                          }),
                    ],
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.delete),
      ),
    );
  }
}

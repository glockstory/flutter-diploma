import 'dart:ffi';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

Activity activityModelFromJson(String str) =>
    Activity.fromJson(json.decode(str));
    
String activityModelToJson(Activity data) => json.encode(data.toJson());

class Activity {
  //final ObjectId id;
  final String name;
  final String pictogram;
  final String date;
  final String start;
  final String end;
  final ObjectId coachId;
  final Int32 repeatType;
  final List students;

  const Activity(
      {
        //required this.id,
      required this.name,
      required this.pictogram,
      required this.date,
      required this.start,
      required this.end,
      required this.coachId,
      required this.repeatType,
      required this.students});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
     // id: json['_id'],
      name: json['name'],
      pictogram: json['pictogram'],
      date: json['date'],
      start: json['start'],
      end: json['end'],
      coachId: json['coachId'],
      repeatType: json['repeatType'],
      students: json['students']);

  Map<String, dynamic> toJson() => {
       // '_id': id,
        'name': name,
        'pictogram': pictogram,
        'date': date,
        'start': start,
        'end': end,
        'coachId': coachId,
        'repeatType': repeatType,
        'students': students,
      };

  // Map<String, dynamic> toMap() {
  //   return {
  //     '_id': id,
  //     'name': name,
  //     'pictogram': pictogram,
  //     'date': date,
  //     'start': start,
  //     'end': end,
  //     'coachId': coachId,
  //     'repeatType': repeatType,
  //     'students': students,
  //   };
  // }

  // Activity.fromMap(Map<String, dynamic> map)
  //     : id = map['_id'],
  //       name = map['name'],
  //       pictogram = map['pictogram'],
  //       date = map['date'],
  //       start = map['start'],
  //       end = map['end'],
  //       coachId = map['coachId'],
  //       repeatType = map['repeatType'],
  //       students = map['students'];
}

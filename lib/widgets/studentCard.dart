import 'package:flutter/material.dart';
import 'package:flutter_final/models/student.dart';
import 'package:flutter_final/pages/studentSettings.dart';
import 'package:flutter_final/styles/textstyle.dart';

class StudentCardWidget extends StatefulWidget {
  final Student student;
  const StudentCardWidget({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentCardWidget> createState() => _StudentCardWidgetState();
}

class _StudentCardWidgetState extends State<StudentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Card(
          key: UniqueKey(),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(children: [
                        Icon(Icons.person_2_rounded),
                        Text(
                          widget.student.name,
                          style: logoText,
                        ),
                      ]),
                    ),
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          final studentId = widget.student.id;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentSettings(
                                        studentId: studentId,
                                      )));
                        },
                        child: Icon(Icons.settings),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(onTap: () {}, child: Icon(Icons.qr_code))
                    ]),
                  ]),
            ),
          ),
        ));
  }
}

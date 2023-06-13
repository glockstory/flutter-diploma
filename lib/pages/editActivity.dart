import 'package:flutter/material.dart';
import 'package:flutter_final/models/activity.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/widgets/imagePicker.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_final/widgets/studentsPicker.dart';
import 'package:flutter_final/widgets/twoButtons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';

class EditActivity extends StatefulWidget {
  //Необязательная переменная получения ссылки на пиктограмму при редактировании события из класса ImagePickerWidget
  static String? imageUrl;
  //Необязательная переменная получения выделенных студентов из виджета StudentPicker
  static List? selectedStudentsToSend;
  //id редактируемого события
  final String activityId;

  const EditActivity({super.key, required this.activityId});

  @override
  State<EditActivity> createState() => _EditActivityState();
}

//Список значений для dropdownbutton
const List<String> list = <String>[
  'Никогда',
  'Каждый день',
  'Каждую неделю',
  'Каждый месяц'
];

//индекс выбранного значения dropdownbutton
int selectedRepeatType = 0;

class _EditActivityState extends State<EditActivity> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeStartController = TextEditingController();
  TextEditingController _timeEndController = TextEditingController();
  List<bool> _isSelected = [false, false];

    //функция вызова диалога подверждения удаления активности

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure to delete this activity?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                //DELETE
                await deleteActivity();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //функция вызова диалога подверждения изменения активности
  Future<void> _showConfirm() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Successful edited'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
            ),
          ],
        );
      },
    );
  }

  //Список событий
  List<Activity> activities = [];
  //Выбранная пиктограмма
  String selectedImg = '';
  
  //Функция изменения события (запрос на сервер)
  Future putActivity() async {
    final activityId = widget.activityId;
    final List<String> studentsId = [];

    if (EditActivity.selectedStudentsToSend != null) {
      for (var element in EditActivity.selectedStudentsToSend!) {
        final id = element.id;
        studentsId.add(id);
      }
    }
    print('heelo ${EditActivity.imageUrl}');
    final Uri uri =
        Uri.parse('http://10.0.2.2:3000/api/activities/$activityId');
    final response = await http.put(
      uri,
      body: jsonEncode(
        <String, dynamic>{
          'name': _titleController.text,
          'date': _dateController.text,
          'start': _timeStartController.text,
          'end': _timeEndController.text,
          'pictogram': EditActivity.imageUrl ?? '',
          'repeatType': selectedRepeatType.toString(),
          'students': studentsId,
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      print('Success edited!');
      _showConfirm();
    } else {
      print(response.body);
    }
  }

  //Функция поиска события (запрос на сервер)
  Future<void> findActivity() async {
    final activityId = widget.activityId;
    print(activityId);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/activity/$activityId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> activitiesJson = json.decode(response.body);
      activities =
          activitiesJson.map((json) => Activity.fromJson(json)).toList();
      activities.forEach(
        (element) {
          _titleController.text = element.name;
          _dateController.text = element.date;
          _timeStartController.text = element.start;
          _timeEndController.text = element.end;
          selectedImg = element.pictogram;
          selectedRepeatType = element.repeatType;
          // ??? select students
          // ??? repeatType

          //print(title);
          //print(date);
        },
      );
      print(activities);
    }
  }

  //Функция удаления активности (запрос на сервер)
  Future<void> deleteActivity() async {
    final activityId = widget.activityId;
    final Uri uri =
        Uri.parse('http://10.0.2.2:3000/api/activities/$activityId');
    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 200) {
      print('Success deleted!');
    } else {
      print(response.body);
    }
  }

  //Инициализация страницы
  @override
  void initState() {
    super.initState();
    findActivity();
  }

  final _formKey = GlobalKey<FormState>();
  //Выбранное значение для dropdowmButton
  String dropdownvalue = list[selectedRepeatType];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Изменение активности'),
        ),
        body: FutureBuilder(
            future: findActivity(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            //key: _formKey,
                            controller: _titleController,
                            style: logoText,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: 'Введите заголовок',
                                border: InputBorder.none),
                            onChanged: (value) {
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: _formKey,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter value';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.none,
                                  showCursor: false,
                                  enableInteractiveSelection: false,
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                      labelText: 'Дата',
                                      suffixIcon: Icon(Icons.calendar_today)),
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(2022, 1, 1),
                                      maxTime: DateTime(2023, 12, 31),
                                      onConfirm: (date) {
                                        setState(() {
                                          if (date != null) {
                                            setState(() {
                                              _dateController.text =
                                                  DateFormat('dd.MM.yy')
                                                      .format(date);
                                            });
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.none,
                                  controller: _timeStartController,
                                  showCursor: false,
                                  enableInteractiveSelection: false,
                                  decoration: InputDecoration(
                                      labelText: 'Начало',
                                      suffixIcon: Icon(Icons.access_time)),
                                  onTap: () {
                                    DatePicker.showTimePicker(
                                      context,
                                      showSecondsColumn: false,
                                      onConfirm: (time) {
                                        setState(() {
                                          _timeStartController.text =
                                              DateFormat.Hm().format(time);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.none,
                                  controller: _timeEndController,
                                  showCursor: false,
                                  enableInteractiveSelection: false,
                                  decoration: InputDecoration(
                                      labelText: 'Окончание',
                                      suffixIcon: Icon(Icons.access_time)),
                                  onTap: () {
                                    DatePicker.showTimePicker(
                                      context,
                                      showSecondsColumn: false,
                                      onConfirm: (time) {
                                        setState(() {
                                          _timeEndController.text =
                                              DateFormat.Hm().format(time);
                                        });
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Изображение',
                                    style: simpleText,
                                  ),
                                  ImagePickerWidget(selectedImage: selectedImg),
                                  const SizedBox(height: 8.0),
                                  const Text('Тип активности',
                                      style: simpleText),
                                  const SizedBox(height: 8.0),
                                  const TwoButtonWidget(),
                                  const SizedBox(height: 16.0),
                                  const Text('Студенты', style: simpleText),
                                  // TODO: FIX active
                                  const StudentPickerWidget(),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Повторять',
                                    style: simpleText,
                                  ),
                                  DropdownButton(
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      value: dropdownvalue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownvalue = value!;
                                          selectedRepeatType =
                                              list.indexOf(dropdownvalue);
                                        });
                                      })
                                ]),
                          ),
                          SizedBox(height: 60)
                        ],
                      ),
                    ));
              }
            }),
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
              //SAVE
              putActivity();
              //Navigator.pop(context);
            },
            heroTag: null,
          )
        ]));
  }
}

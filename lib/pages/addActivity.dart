import 'package:flutter/material.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/widgets/imagePicker.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:flutter_final/widgets/studentsPicker.dart';
import 'package:flutter_final/widgets/twoButtons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';

class AddActivity extends StatefulWidget {
  //Необязательная переменная получения ссылки на пиктограмму при редактировании события из класса ImagePickerWidget
  static String? imageUrl;
  //Необязательная переменная получения выделенных студентов из виджета StudentPicker
  static List? selectedStudentsToSend;

  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
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

class _AddActivityState extends State<AddActivity> {
  //Контроллеры соответствующих полей
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeStartController = TextEditingController();
  TextEditingController _timeEndController = TextEditingController();
  //Значение для dropdownbutton по умолчанию
  String dropdownvalue = list.first;
  //функция вызова диалога подверждения создания активности
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Activity is created'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                //ВЫХОД ИЗ СТРАНИЦЫ НА КАЛЕНДАРЬ
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
            ),
          ],
        );
      },
    );
  }

  //Функция создания уведомления (запрос на сервер) 
  Future<void> createNotification(responseActivityId) async {
    final activityId = json.decode(responseActivityId);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    mongo.ObjectId coachId = mongo.ObjectId.parse(userId!);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/notifications/create');

    final response = await http.post(
      uri,
      body: jsonEncode(
        <String, dynamic>{
          'activityId': activityId,
          'date': _dateController.text,
          'coachId': coachId,
          'start': _timeStartController.text,
          'end': _timeEndController.text,
          'name': _titleController.text
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('ok');
    } else {
      print(response.body);
      throw Exception('Failed to create activity');
    }
  }

  //Функция создания события (запрос на сервер)
  Future<void> createActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    mongo.ObjectId coachId = mongo.ObjectId.parse(userId!);
    final Uri uri = Uri.parse('http://10.0.2.2:3000/activities/create');
    final List<String> studentsId = [];

    if (AddActivity.selectedStudentsToSend != null) {
      for (var element in AddActivity.selectedStudentsToSend!) {
        final id = element.id;
        studentsId.add(id);
      }
    }

    final response = await http.post(
      uri,
      body: jsonEncode(
        <String, dynamic>{
          'name': _titleController.text,
          'date': _dateController.text,
          'start': _timeStartController.text,
          'end': _timeEndController.text,
          'pictogram': AddActivity.imageUrl ?? '',
          'repeatType': selectedRepeatType.toString(),
          'coachId': coachId,
          'students': studentsId,
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    print(response.statusCode);
    print('FUUCK YOUUUUUUUUUUU ${response.body}');
    if (response.statusCode == 201) {
      await createNotification(response.body);
      await _showMyDialog();
    } else {
      print(response.body);
      throw Exception('Failed to create activity');
    }
  }

  //Глобальный ключ 
  final _formKey = GlobalKey<FormState>();


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Создание активности'),
      ),
      body: Container(
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
                      hintText: 'Введите заголовок', border: InputBorder.none),
                  onChanged: (value) {
                    //TODO: save value
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
                                        DateFormat('dd.MM.yy').format(date);
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
                        ImagePickerWidget(selectedImage: ''),
                        const SizedBox(height: 8.0),
                        const Text('Тип активности', style: simpleText),
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
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
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
                MyButton(
                    label: 'Создать',
                    onTap: () {
                      createActivity();
                    })
              ],
            ),
          )),
    );
  }
}

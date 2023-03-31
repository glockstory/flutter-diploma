import 'package:flutter/material.dart';
import 'package:flutter_final/widgets/imagePicker.dart';
import 'package:flutter_final/styles/textstyle.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_final/widgets/button.dart';
import 'package:flutter_final/widgets/studentsPicker.dart';
import 'package:flutter_final/widgets/twoButtons.dart';
import 'package:intl/intl.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

const List<String> list = <String>[
  'Никогда',
  'Каждый день',
  'Каждую неделю',
  'Каждый месяц'
];

class _AddActivityState extends State<AddActivity> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeStartController = TextEditingController();
  TextEditingController _timeEndController = TextEditingController();
  List<bool> _isSelected = [false, false];
  //List<String> names = ['Avraam', 'Nikita', 'George', 'Mark'];

  String dropdownvalue = list.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Создание активности'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
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
                  child: TextField(
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
                  child: TextField(
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
                  child: TextField(
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
                    ImagePickerWidget(),
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
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: dropdownvalue,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue = value!;
                          });
                        })
                    // ToggleButtons(
                    //     children: <Widget>[
                    //       Text('Общая'),
                    //       Text('Индивидуальная')
                    //     ],
                    //     isSelected: _isSelected,
                    //     selectedColor: primaryClr,
                    //     color: Colors.grey,
                    //     onPressed: (int index) {
                    //       setState(() {
                    //         for (var i = 0; i < _isSelected.length; i++) {
                    //           _isSelected[i] = i == index;
                    //         }
                    //       });
                    //     }),
                  ]),
            ),
            MyButton(
                label: 'Создать',
                onTap: () {
                  //TODO: Create activity
                })
          ],
        ),
      ),
    );
  }
}

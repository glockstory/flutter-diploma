import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_final/pages/addActivity.dart';
import 'package:flutter_final/pages/auntification.dart';
import 'package:flutter_final/pages/calendar.dart';
import 'package:flutter_final/pages/mainPage.dart';
import 'package:flutter_final/pages/register.dart';
import 'package:flutter_final/database/database.dart';
import 'package:flutter_final/pages/testpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MainPage()));
}

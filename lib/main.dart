import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_final/pages/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MainPage()));
}

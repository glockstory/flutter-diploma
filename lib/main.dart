import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Войти в Routine Supprt',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
                        borderRadius: BorderRadius.circular(8.0)),
                    hintText: 'Enter email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
                        borderRadius: BorderRadius.circular(8.0)),
                    hintText: 'Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_final/pages/auntification.dart';
import 'package:flutter/gestures.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final TextStyle logoText = const TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600);
  final TextStyle simpleText = const TextStyle(
      color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w400);
  final TextStyle linkStyle = const TextStyle(
      color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.w400);
  final String logoImage = 'assets/logo.png';
  final ButtonStyle styleButton = ButtonStyle(
    minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
  );
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
            Expanded(
              child: Column(
                children: [
                  Image.asset(logoImage),
                  const SizedBox(height: 5),
                  Text(
                    'Войти в Routine Support',
                    style: logoText,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.0),
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.0),
                            borderRadius: BorderRadius.circular(8.0)),
                        hintText: 'Password'),
                  ),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Еще не зарегистрированы? ', style: simpleText),
                    TextSpan(
                        text: 'Создать аккаунт.',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => () {}),
                  ]),
                ),
              ]),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthPage()));
                  },
                  style: styleButton,
                  child: const Text('Войти'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

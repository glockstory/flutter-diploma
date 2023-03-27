/*Для реализации навигации в Flutter можно использовать виджет Navigator. 
Примерно так:

1. Создать новую страницу (widget) в отдельном файле. 
   Например, файл "SecondPage.dart":

```
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
      ),
      body: Center(
        child: Text("This is the Second Page"),
      ),
    );
  }
}
```

2. Создать главную страницу (widget) и добавить на неё кнопку для перехода на вторую страницу. 
   Например, файл "MainPage.dart":

```
import 'package:flutter/material.dart';
import 'SecondPage.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
      ),
      body: Center(dsd
        child: RaisedButton(
          child: Text("Go to Second Page"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
        ),
      ),
    );
  }
}
```

3. Добавить маршрут для главной страницы в функцию runApp(), создать экземпляр главного виджета и запустить приложение:

```
import 'package:flutter/material.dart';
import 'MainPage.dart';

void main() => runApp(MaterialApp(
      title: 'Navigation Example',
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/second': (context) => SecondPage(),
      },
    ));
```

Это упрощенный пример навигации с двумя страницами, но вы можете добавить сколько угодно страниц и своих собственных маршрутов.
*/
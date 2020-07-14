import 'package:kiouttest/global_services.dart';
import 'package:kiouttest/model/order/order_type.dart';
import 'package:kiouttest/pages/preorder_editor.dart';
import 'package:kiouttest/services/burial_preorder_editor_bloc.dart';
import 'package:kiouttest/services/cemeteries_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  service.registerLazySingleton<CemeteriesCache>(() => CemeteriesCache());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF084B2A);
    const accentColor = Color(0xFF009937);
    return MaterialApp(
      title: 'Честный Агент',
      theme: ThemeData(
        brightness: Brightness.light,
        cupertinoOverrideTheme: CupertinoThemeData(primaryColor: primaryColor),
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            colorScheme: ColorScheme(
                secondaryVariant: accentColor,
                onError: accentColor,
                background: accentColor,
                error: Colors.green,
                onBackground: accentColor,
                onPrimary: accentColor,
                onSecondary: accentColor,
                onSurface: accentColor,
                primary: accentColor,
                primaryVariant: accentColor,
                secondary: accentColor,
                surface: Colors.white,
                brightness: Brightness.light)),
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        // Цвет для выбранных чекбоксов, радиобатонов и тд
        toggleableActiveColor: accentColor,
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: accentColor, width: 2))),
        // Цвет для заднего фона основной
        primaryColor: primaryColor,
        // Цвет используется для кнопок
        buttonColor: accentColor,
        accentColor: accentColor,
        // использован во всплывающих сообщениях
//        bottomAppBarColor: const Color(0xFF373737),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
//        bott
        cursorColor: primaryColor,
        primaryTextTheme: TextTheme(
            caption: TextStyle(fontSize: 16, color: const Color(0xFF717171)),
            // Размер большого текста, используется в календаре для верхней строки
            headline4: TextStyle(fontSize: 32.0),
            bodyText2:
            TextStyle(fontSize: 14.0, color: const Color(0xFF3B3B3B))),
        fontFamily: 'Roboto',
      ),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU'),
      ],
      home: PreorderEditor(BurialPreorderEditorBloc.createBlank(OrderType.burial)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

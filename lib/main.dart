import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/State_app.dart';
import 'package:flutter/material.dart';
import 'package:bit/src/rust/frb_generated.dart';

import 'home.dart'; // home

Future<void> main() async {
  await RustLib.init();
  // Here we can load data saved to disk, Not sure when we'd write config to disk
  // Need to investigate how Darts lifecycle stuff works.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppState state = AppState();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // define app colors
    const Color backgroundColor = Color(0xFF1C1C20); // sark background color
    const Color mainTextColor =
        Color.fromARGB(255, 111, 159, 169); // Main content text color

    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          textTheme:
              const TextTheme(bodyLarge: TextStyle(color: mainTextColor)),
        ),
        home: HomePage(state: state));
  }
}

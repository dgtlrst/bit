import 'package:bit/src/rust/api/serial.dart';
import 'package:flutter/material.dart';
import 'package:bit/src/rust/frb_generated.dart';

import 'home.dart'; // home


Future<void> main() async {
    await RustLib.init();
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        // define app colors
        const Color backgroundColor = Color(0xFF1C1C20); // sark background color
        const Color mainTextColor = Color.fromARGB(255, 111, 159, 169); // Main content text color

        return MaterialApp(
            theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: backgroundColor,
                textTheme: const TextTheme(bodyLarge: TextStyle(color: mainTextColor)),
            ),
            home: HomePage()
        );
    }
}

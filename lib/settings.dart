import 'package:flutter/material.dart';
import 'package:bit/src/rust/api/simple.dart';

import 'sidepanel.dart'; // side panel

class Settings extends StatelessWidget {
    const Settings({super.key});

    @override
    Widget build(BuildContext context) {
    // define app colors
    const Color textFieldColor = Color.fromARGB(255, 23, 29, 35); // Slightly darker TextField background color
    const Color textFieldTextColor = Color.fromARGB(255, 200, 220, 224); // Slightly different TextField text color
    const Color mainTextColor = Color.fromARGB(255, 144, 168, 174); // Slightly different Main content text color

    return Scaffold(
        appBar: AppBar(title: const Text('settings')),
        body: Row(
            children: [

            // main content
            const SidePanel(SidePanelPage.settings),

            Expanded(
                child: Column(
                children: [
                    Expanded(
                    child: Center(
                        child: Text(
                        'rust -> ${greet(name: "type something..")}',
                        style: const TextStyle(color: mainTextColor),
                        ),
                    ),
                    ),
                    const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                        style: TextStyle(color: textFieldTextColor),
                        decoration: InputDecoration(
                        filled: true,
                        fillColor: textFieldColor,
                        border: OutlineInputBorder(),
                        labelText: 'type..',
                        labelStyle: TextStyle(color: textFieldTextColor),
                        ),
                    ),
                    ),
                ],
                ),
            ),
            ],

        ),
        );
    }
}

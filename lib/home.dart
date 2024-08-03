import 'package:flutter/material.dart';
import 'package:bit/src/rust/api/simple.dart';

import 'sidepanel.dart'; // side panel

class HomePage extends StatelessWidget {
    const HomePage({super.key});

    @override
    Widget build(BuildContext context) {
        const Color textFieldColor =
        Color(0xFF26303B); // TextField background color
        const Color textFieldTextColor =
        Color.fromARGB(255, 96, 135, 142); // TextField text color
        const Color mainTextColor =
        Color.fromARGB(255, 111, 159, 169); // Main content text color

        return Scaffold(
            appBar: AppBar(title: const Text('terminal')),
            body: Row(
            children: [

                const SidePanel(SidePanelPage.home), // main content

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

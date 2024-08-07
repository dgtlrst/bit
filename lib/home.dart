import 'dart:async';
import 'dart:io';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:bit/terminal.dart';
import 'package:flutter/material.dart';
import 'sidepanel.dart'; // side panel

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<HomePage> {
  final Controller controller = Controller();

  Widget createTerminalGrid() {
    int num_of_terminals =
        4; // TODO: Make this configurable with global settings page at some point
    List<Terminal> terminals = [];
    for (var i = 0; i < num_of_terminals; i++) {
      terminals.add(Terminal(
        controller: controller,
        threadId: i,
      ));
    }

    var grid = GridView.count(
      padding: const EdgeInsets.all(20),
      childAspectRatio: 5 / 2,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 20, // Adjust horizontal spacing
      crossAxisCount: 2,
      children: terminals,
    );
    return Expanded(child: grid);
  }

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

          createTerminalGrid()
        ],
      ),
    );
  }
}

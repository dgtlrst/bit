import 'dart:async';
import 'dart:io';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:bit/state.dart';
import 'package:bit/terminal.dart';
import 'package:flutter/material.dart';
import 'sidepanel.dart'; // side panel

class HomePage extends StatefulWidget {
  final AppState state;
  const HomePage({super.key, required this.state});
  @override
  State<HomePage> createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<HomePage> {
  Widget createTerminalGrid() {
    int num_of_terminals =
        4; // TODO: Make this configurable with global settings page at some point
    List<Terminal> terminals = [];
    for (var i = 0; i < num_of_terminals; i++) {
      terminals.add(Terminal(
        threadId: i,
        state: widget.state,
      ));
    }

    // TODO: GridViews are scrollable which we don't really want
    // We'll just have to manually make a row/column set for 1x1, 2x1, 1x2, 2x2
    // and handle it that way.
    var grid = GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      childAspectRatio: 16 / 9,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 10, // Adjust horizontal spacing
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
          SidePanel(SidePanelPage.home, widget.state), // main content
          createTerminalGrid()
        ],
      ),
    );
  }
}

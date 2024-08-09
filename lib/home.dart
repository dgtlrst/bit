import 'dart:async';
import 'dart:io';

import 'package:bit/State_globals.dart';
import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:bit/State_app.dart';
import 'package:bit/terminal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'sidepanel.dart'; // side panel

class HomePage extends StatefulWidget {
  final AppState state;
  const HomePage({super.key, required this.state});
  @override
  State<HomePage> createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<HomePage> {
  Widget createTerminalGrid() {
    Layout layout = widget.state.globalSettings.layout;
    int num_of_terminals = 1;
    print(layout);
    List<Widget> terminals;
    double childAspectRatio;
    int crossAxisCount;
    var size = MediaQuery.sizeOf(context);
    double aspect = size.width / size.height;
    int heightOffset = 0;
    int widthOffset = -100;
    switch (layout) {
      case Layout.oneByOne:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
        ];
        childAspectRatio = aspect;
        crossAxisCount = 1;
      case Layout.oneByTwo:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1)
        ];
        childAspectRatio = aspect / 2;
        // heightOffset = 200;
        crossAxisCount = 2;
      case Layout.twoByOne:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1)
        ];
        childAspectRatio = aspect * 2;
        crossAxisCount = 1;
      case Layout.twoByTwo:
        childAspectRatio = aspect;
        crossAxisCount = 2;
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1),
          Terminal(state: widget.state, threadId: 2),
          Terminal(state: widget.state, threadId: 3)
        ];
    }
    var grid = GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 10, // Adjust horizontal spacing
      crossAxisCount: crossAxisCount,
      children: terminals,
    );

    return Center(
        child: SizedBox(
            height: size.height + heightOffset,
            width: size.width + widthOffset,
            child: grid));
    // var size = MediaQuery.sizeOf(context);
    // return ConstrainedBox(
    //     constraints:
    //         BoxConstraints(maxHeight: size.height, maxWidth: size.width),
    //     child: Expanded(child: grid));
  }

  // List<Terminal> terminals = [];
  // for (var i = 0; i < num_of_terminals; i++) {
  //   terminals.add(Terminal(
  //     threadId: i,
  //     state: widget.state,
  //   ));
  // }

  // // TODO: GridViews are scrollable which we don't really want
  // // We'll just have to manually make a row/column set for 1x1, 2x1, 1x2, 2x2
  // // and handle it that way.
  // var grid = GridView.count(
  //   shrinkWrap: true,
  //   padding: const EdgeInsets.all(10),
  //   childAspectRatio: 16 / 9,
  //   mainAxisSpacing: 10, // Adjust vertical spacing
  //   crossAxisSpacing: 10, // Adjust horizontal spacing
  //   crossAxisCount: 2,
  //   children: terminals,
  // );
  // return Expanded(child: grid);

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
          SidePanel(SidePanelPage.home, widget.state),
          createTerminalGrid()
        ],
      ),
    );
  }
}

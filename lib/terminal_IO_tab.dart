import 'dart:async';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:bit/state.dart';
import 'package:bit/terminal_settings_tab.dart';
import 'package:flutter/material.dart';

import 'sidepanel.dart'; // side panel

class TerminalIOTab extends StatefulWidget {
  final int threadId;
  final AppState state;
  const TerminalIOTab({
    super.key,
    required this.state,
    required this.threadId,
  });
  @override
  State<TerminalIOTab> createState() => _CreateTerminalIOTabState();
}

class _CreateTerminalIOTabState extends State<TerminalIOTab>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late Stream<String> stream;
  late StreamSubscription<String> listener;
  late List<String> _data;
  late Controller controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode myFocus = FocusNode();
  double lastOffset = 0.0;
  @override
  void initState() {
    super.initState();
    _data = widget.dataStore;
    controller = widget.controller;
    stream = widget.stream;
    print("Thread Id in Dart: ${widget.threadId}");
    listener = stream.listen(
        streamHandler()); // This listener is to update scroll position and force rerender
    // The one passed in only updates the datastore but we need to resume and pause it
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  void Function(String) streamHandler() {
    return (String data) {
      if (mounted) {
        setState(() {});
        print("Length of _data: ${_data.length}");
        print("Receiving Data in Stream: $data");
      }
    };
  }

  void onSubmitted(String value) {
    print("Sending to Rust: '${_controller.text}'");
    controller.push(threadId: widget.threadId, data: value);
    _controller.clear();
  }

  Widget create_output() {
    List<Widget> widgets = _data.map((e) {
      return Text(e);
    }).toList();
    return Expanded(
        child: ListView(
      reverse: true,
      controller: _scrollController,
      children: widgets.reversed.toList(),
    ));
  }

  Widget connect_disconnect_binary() {
    var connected = true;
    if (connected) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child:
            IconButton.filled(onPressed: () => {}, icon: Icon(Icons.power_off)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: IconButton.filled(onPressed: () => {}, icon: Icon(Icons.power)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color textFieldColor =
        Color(0xFF26303B); // TextField background color
    const Color textFieldTextColor =
        Color.fromARGB(255, 96, 135, 142); // TextField text color
    const Color mainTextColor =
        Color.fromARGB(255, 111, 159, 169); // Main content text color
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Column(
        children: [
          create_output(),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    focusNode: myFocus,
                    controller: _controller,
                    onSubmitted: (value) {
                      onSubmitted(value);
                      myFocus.requestFocus();
                    },
                    style: const TextStyle(color: textFieldTextColor),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(),
                      labelText: 'type..',
                      labelStyle: TextStyle(color: textFieldTextColor),
                    ),
                  )),
                  connect_disconnect_binary()
                ],
              ))
        ],
      ),
    );
  }
}

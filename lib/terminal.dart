import 'dart:async';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';

import 'sidepanel.dart'; // side panel

class Terminal extends StatefulWidget {
  final Controller controller;
  final int threadId;
  const Terminal({super.key, required this.controller, required this.threadId});
  @override
  State<Terminal> createState() => _CreateTerminalState();
}

class _CreateTerminalState extends State<Terminal> {
  final TextEditingController _controller = TextEditingController();
  late Stream<String?> stream;
  late StreamSubscription<String?> listener;
  final List<String> _data = [];
  final Controller controller = Controller();
  late int thread_id = widget.threadId;

  @override
  void initState() {
    super.initState();
    controller.setNewThreadId(threadId: thread_id);
    stream = controller.createStream();
    print("Thread Id in Dart: $thread_id");
    listener = stream.listen(streamHandler());
  }

  void Function(String?)? streamHandler() {
    return (String? data) {
      if (mounted) {
        if (data != null) {
          setState(() {
            _data.add(data);
          });
          print("Length of _data: ${_data.length}");
          print("Receiving Data in Stream: $data");
        }
      }
    };
  }

  Null Function(dynamic) onSubmitted() {
    return (value) {
      print("Sending to Rust: '${_controller.text}'");
      controller.push(threadId: thread_id, data: value);
      _controller.clear();
    };
  }

  Widget create_output() {
    List<Widget> widgets = _data.map((e) {
      return Text(e);
    }).toList();
    return Expanded(child: Column(children: widgets));
  }

  @override
  Widget build(BuildContext context) {
    const Color textFieldColor =
        Color(0xFF26303B); // TextField background color
    const Color textFieldTextColor =
        Color.fromARGB(255, 96, 135, 142); // TextField text color
    const Color mainTextColor =
        Color.fromARGB(255, 111, 159, 169); // Main content text color
    return Expanded(
      child: Column(
        children: [
          create_output(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onSubmitted: onSubmitted(),
              style: const TextStyle(color: textFieldTextColor),
              decoration: const InputDecoration(
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
    );
  }
}

import 'dart:async';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:bit/src/rust/api/simple.dart';

import 'sidepanel.dart'; // side panel

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final Echo _rust = Echo();
  late Stream<String?> stream;
  late StreamSubscription<String?> listener;
  final List<String> _data = [];
  final Controller controller = Controller();
  late int thread_id;

  @override
  void initState() {
    super.initState();
    stream = controller.createStream();
    thread_id = controller.getLatestThreadCreated();
    //stream = create_stream();
    //stream = _rust.createStream();
    listener = stream.listen(streamHandler());
  }

  void Function(String?)? streamHandler() {
    return (String? data) {
      if (data != null) {
        setState(() {
          _data.add(data);
        });
        print("Length of _data: ${_data.length}");
        print("Receiving Data in Stream: $data");
      }
    };
  }

  Stream<String?> create_stream() async* {
    while (true) {
      String? s = await _rust.pop();
      yield s;
    }
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

  // Widget create_stream_widget() {
  //   return Expanded(
  //       child: StreamBuilder(
  //     stream: create_stream(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         // Display the data from the stream
  //         return Text('Number: ${snapshot.data}');
  //       } else if (snapshot.hasError) {
  //         // Handle error case
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         print(
  //             "${snapshot.hasData}, ${snapshot.hasError}, ${snapshot.connectionState}");
  //         // Handle loading or initial state
  //         return CircularProgressIndicator.adaptive();
  //       }
  //     },
  //   ));
  // }

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
          ),
        ],
      ),
    );
  }
}

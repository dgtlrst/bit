import 'dart:async';
import 'package:bit/state_terminal.dart';
import 'package:flutter/material.dart';
import 'package:bit/state_app.dart';

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
  StreamSubscription<String>? listener;
  late List<String> _data;
  final ScrollController _scrollController = ScrollController();
  final FocusNode myFocus = FocusNode();
  late TerminalState terminalState;

  @override
  void initState() {
    super.initState();
    terminalState = widget.state.getTerminalState(widget.threadId)!;
    _data = terminalState.getTerminalData();
    if (terminalState.connected) {
      connect();
    }
    print("Thread Id in Dart: ${widget.threadId}");
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  void connect() {
    terminalState.connectIfNotConnected();
    Stream<String>? stream = terminalState.getTerminalStream();
    if (stream == null) {
      throw Exception(
          "Something went wrong in creating the Stream. Error handling needs to be implemented!");
    } else {
      listener = stream.listen(streamHandler());
      setState(() {});
    }
  }

  void disconnect() {
    terminalState.disconnectIfNotDisconnected();
    setState(() {});
  }

  void Function(String) streamHandler() {
    return (String data) {
      if (mounted) {
        // When this widget is mounted aka is being shown
        // We use setState to simply rerender every time an event is emitted
        // The data continues to get stored in widget.state regardless of
        // whether the widget is getting rendered without setState to
        // decouple data gathering from rendering.
        setState(() {});
        print("Length of _data: ${_data.length}");
        print("Receiving Data in Stream: $data");
      }
    };
  }

  void onSubmitted(String value) {
    terminalState.push(value);
    _controller.clear();
  }

  Widget createOutput() {
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

  Widget connectDisconnectBinary() {
    if (terminalState.connected) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: IconButton.filled(
            onPressed: () => disconnect(), icon: const Icon(Icons.power_off)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: IconButton.filled(
            onPressed: () => connect(), icon: const Icon(Icons.power)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color textFieldColor =
        Color(0xFF26303B); // TextField background color
    const Color textFieldTextColor =
        Color.fromARGB(255, 96, 135, 142); // TextField text color
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Column(
        children: [
          createOutput(),
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
                  connectDisconnectBinary()
                ],
              ))
        ],
      ),
    );
  }
}

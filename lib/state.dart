// This class owns all streams and connectors and other data for the UI
// so that the data can be continously updated without necessarily rebuilding the
// widget tree.

import 'dart:async';
import 'dart:collection';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';

class TerminalState {
  final int threadId;
  bool connected = false;
  final Controller controller;
  Stream<String>? _stream;
  StreamSubscription<String>? _listener;
  final SerialPortInfo settings = SerialPortInfo(
      name: "",
      speed: 9600,
      dataBits: DataBits.eight,
      parity: Parity.none,
      stopBits: StopBits.one,
      flowControl: FlowControl.none);
  bool inUse = false;
  final List<String> _rxData = [];
  TerminalState({required this.threadId, required this.controller});

  void connectIfNotConnected() {
    if (!connected) {
      print("Thread $threadId: Connecting");
      controller.setNewThreadId(threadId: threadId);
      _stream = controller.createStream().asBroadcastStream();
      _listener = _stream!.listen(
          streamHandler()); // Stream should exist since we just created the stream
      connected = true;
    }
  }

  void disconnectIfNotDisconnected() {
    if (connected) {
      print("Thread $threadId: Disconnecting");
      controller.endStream(threadId: threadId);
      if (_listener != null) {
        _listener!.cancel();
        _listener = null;
      }
      _stream = null;
      connected = false;
    }
  }

  void push(String data) {
    print("Thread $threadId: Sending to Rust: '$data'");
    controller.push(threadId: threadId, data: data);
  }

  Stream<String>? getTerminalStream() {
    // To allow a widget to set up a subscription
    return _stream;
  }

  List<String> getTerminalData() {
    return _rxData;
  }

  void Function(String) streamHandler() {
    return (String data) {
      print("Thread $threadId: Receving '$data'");
      _rxData.add(data);
    };
  }
}

class AppState {
  final Controller _controller = Controller();
  final HashMap<int, TerminalState> _threads = HashMap();
  AppState();

  void newTerminalState(int threadId) {
    if (getTerminalState(threadId) != null) {
      throw Exception("This thread already exists");
    }
    // Returns threadId
    _controller.setNewThreadId(threadId: threadId);
    TerminalState terminal =
        TerminalState(threadId: threadId, controller: _controller);
    // No need to check
    // Whether existing terminal in HashMap since we always increment by one
    // If a user maxes out a 64 bit integer that's on them.
    _threads.putIfAbsent(threadId, () => terminal);
  }

  void deleteTerminal(int threadId) {
    var thread = _threads[threadId];
    if (thread != null) {
      thread.disconnectIfNotDisconnected();
    } else {
      print("Terminal with Id: $threadId does not exist");
    }
    _threads.remove(threadId);
  }

  TerminalState? getTerminalState(int threadId) {
    return _threads[threadId];
  }

  TerminalState getThreadAndCreateIfNotExist(int threadId) {
    TerminalState? terminal = getTerminalState(threadId);
    if (terminal != null) {
      return terminal;
    } else {
      // If not yet returned create new thread
      newTerminalState(threadId);
      TerminalState state = getTerminalState(threadId)!;
      state.inUse = true;
      return state;
    }
  }
}

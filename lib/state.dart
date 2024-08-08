// This class owns all streams and connectors and other data for the UI
// so that the data can be continously updated without necessarily rebuilding the
// widget tree.

import 'dart:async';
import 'dart:collection';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';

class TerminalState {
  final int threadId;
  final Stream<String> stream;
  late StreamSubscription<String> _listener;
  final SerialPortInfo settings = SerialPortInfo(
      name: "",
      speed: 9600,
      dataBits: DataBits.eight,
      parity: Parity.none,
      stopBits: StopBits.one,
      flowControl: FlowControl.none);
  bool in_use = false;
  final List<String> _rxData = [];
  TerminalState({required this.threadId, required this.stream}) {
    _listener = stream.listen(streamHandler());
  }

  Stream<String> getTerminalStream() {
    // To allow a widget to set up a subscription
    return stream;
  }

  List<String> getTerminalData() {
    return _rxData;
  }

  void Function(String) streamHandler() {
    return (String data) {
      _rxData.add(data);
    };
  }
}

class AppState {
  int _threadIdCounter = 0;
  final Controller _controller = Controller();
  HashMap<int, TerminalState> _threads = HashMap();
  AppState();

  int newTerminalState() {
    // Returns threadId
    int threadId = _threadIdCounter;
    _threadIdCounter += 1;
    _controller.setNewThreadId(threadId: threadId);
    Stream<String> stream = _controller.createStream().asBroadcastStream();
    TerminalState terminal = TerminalState(threadId: threadId, stream: stream);
    // No need to check
    // Whether existing terminal in HashMap since we always increment by one
    // If a user maxes out a 64 bit integer that's on them.
    _threads.putIfAbsent(threadId, () => terminal);
    return threadId;
  }

  void pushToTerminal(int threadId, String data) {
    _controller.push(threadId: threadId, data: data);
  }

  void deleteTerminal(int threadId) {
    _controller.endStream(threadId: threadId);
    _threads.remove(threadId);
  }

  TerminalState? getTerminalState(int threadId) {
    return _threads[threadId];
  }

  int getUnusedThreadOrCreateThread() {
    // Returns threadId
    for (TerminalState thread in _threads.values) {
      if (thread.in_use == false) {
        thread.in_use = true;
        return thread.threadId;
      }
    }
    // If not yet returned create new thread
    return newTerminalState();
  }
}

import 'dart:async';

import 'package:bit/state_persistent_datastore.dart';
import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'dart:developer';

class TerminalState {
  final PersistentDataStore dataStore;
  final int threadId;
  bool connected = false;
  late TerminalController controller;
  Stream<String>? _stream;
  StreamSubscription<String>? _listener;
  late SerialPortInfo _settings;
  bool inUse = false;
  final List<String> _rxData = [];
  TerminalState({required this.threadId, required this.dataStore}) {
    controller = TerminalController(threadId: threadId);
    _settings = dataStore.loadTerminalState(threadId);
  }

  void connectIfNotConnected() {
    if (!connected) {
      log("Thread $threadId: Connecting");
      _stream = controller.createStream(sinfo: _settings).asBroadcastStream();
      _listener = _stream!.listen(
          streamHandler()); // Stream should exist since we just created the stream
      connected = true;
    }
  }

  void disconnectIfNotDisconnected() {
    if (connected) {
      log("Thread $threadId: Disconnecting");
      controller.endStream();
      if (_listener != null) {
        _listener!.cancel();
        _listener = null;
      }
      _stream = null;
      connected = false;
    }
  }

  void push(String data) {
    log("Thread $threadId: Sending to Rust: '$data'");
    controller.push(data: data);
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
      log("Thread $threadId: Receving '$data'");
      _rxData.add(data);
    };
  }

  String getSettingsName() {
    return _settings.name;
  }

  int getSettingsSpeed() {
    return _settings.speed;
  }

  DataBits getSettingsDataBits() {
    return _settings.dataBits;
  }

  Parity getSettingsParity() {
    return _settings.parity;
  }

  StopBits getSettingsStopBits() {
    return _settings.stopBits;
  }

  FlowControl getSettingsFlowControl() {
    return _settings.flowControl;
  }

  void setSettingsName(String name) {
    _settings.name = name;
    dataStore.saveTerminalState(threadId, _settings);
  }

  void setSettingsSpeed(int speed) {
    _settings.speed = speed;
    dataStore.saveTerminalState(threadId, _settings);
  }

  void setSettingsDataBits(DataBits dataBit) {
    _settings.dataBits = dataBit;
    dataStore.saveTerminalState(threadId, _settings);
  }

  void setSettingsParity(Parity parity) {
    _settings.parity = parity;
    dataStore.saveTerminalState(threadId, _settings);
  }

  void setSettingsStopBits(StopBits stopBit) {
    _settings.stopBits = stopBit;
    dataStore.saveTerminalState(threadId, _settings);
  }

  void setSettingsFlowControl(FlowControl flowControl) {
    _settings.flowControl = flowControl;
    dataStore.saveTerminalState(threadId, _settings);
  }
}

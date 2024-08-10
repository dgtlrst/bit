import 'dart:async';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';

class TerminalState {
  final int threadId;
  bool connected = false;
  late TerminalController controller;
  Stream<String>? _stream;
  StreamSubscription<String>? _listener;
  final SerialPortInfo _settings = SerialPortInfo(
      name: "",
      speed: 9600,
      dataBits: DataBits.eight,
      parity: Parity.none,
      stopBits: StopBits.one,
      flowControl: FlowControl.none);
  bool inUse = false;
  final List<String> _rxData = [];
  TerminalState({required this.threadId}) {
    controller = TerminalController(threadId: threadId);
  }

  void connectIfNotConnected() {
    if (!connected) {
      print("Thread $threadId: Connecting");
      _stream = controller.createStream().asBroadcastStream();
      _listener = _stream!.listen(
          streamHandler()); // Stream should exist since we just created the stream
      connected = true;
    }
  }

  void disconnectIfNotDisconnected() {
    if (connected) {
      print("Thread $threadId: Disconnecting");
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
    print("Thread $threadId: Sending to Rust: '$data'");
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
      print("Thread $threadId: Receving '$data'");
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
  }

  void setSettingsSpeed(int speed) {
    _settings.speed = speed;
  }

  void setSettingsDataBits(DataBits dataBit) {
    _settings.dataBits = dataBit;
  }

  void setSettingsParity(Parity parity) {
    _settings.parity = parity;
  }

  void setSettingsStopBits(StopBits stopBit) {
    _settings.stopBits = stopBit;
  }

  void setSettingsFlowControl(FlowControl flowControl) {
    _settings.flowControl = flowControl;
  }
}

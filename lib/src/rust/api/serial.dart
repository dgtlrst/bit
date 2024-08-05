// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `main`

List<SerialPortInfo> listAvailablePorts() =>
    RustLib.instance.api.crateApiSerialListAvailablePorts();

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Echo>>
abstract class Echo implements RustOpaqueInterface {
  factory Echo() => RustLib.instance.api.crateApiSerialEchoNew();

  Future<String?> pop();

  void push({required String s});
}

enum DataBits {
  five,
  six,
  seven,
  eight,
  ;

  static DataBits from({required DataBits dataBits}) =>
      RustLib.instance.api.crateApiSerialDataBitsFrom(dataBits: dataBits);
}

enum FlowControl {
  none,
  software,
  hardware,
  ;

  static FlowControl from({required FlowControl flowControl}) =>
      RustLib.instance.api
          .crateApiSerialFlowControlFrom(flowControl: flowControl);
}

enum Parity {
  none,
  odd,
  even,
  ;

  static Parity from({required Parity parity}) =>
      RustLib.instance.api.crateApiSerialParityFrom(parity: parity);
}

class SerialPortInfo {
  final String name;
  final int speed;
  final DataBits dataBits;
  final Parity parity;
  final StopBits stopBits;
  final FlowControl flowControl;

  const SerialPortInfo.raw({
    required this.name,
    required this.speed,
    required this.dataBits,
    required this.parity,
    required this.stopBits,
    required this.flowControl,
  });

  factory SerialPortInfo(
          {required String name,
          required int speed,
          required DataBits dataBits,
          required Parity parity,
          required StopBits stopBits,
          required FlowControl flowControl}) =>
      RustLib.instance.api.crateApiSerialSerialPortInfoNew(
          name: name,
          speed: speed,
          dataBits: dataBits,
          parity: parity,
          stopBits: stopBits,
          flowControl: flowControl);

  @override
  int get hashCode =>
      name.hashCode ^
      speed.hashCode ^
      dataBits.hashCode ^
      parity.hashCode ^
      stopBits.hashCode ^
      flowControl.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerialPortInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          speed == other.speed &&
          dataBits == other.dataBits &&
          parity == other.parity &&
          stopBits == other.stopBits &&
          flowControl == other.flowControl;
}

enum StopBits {
  one,
  two,
  ;

  static StopBits from({required StopBits stopBits}) =>
      RustLib.instance.api.crateApiSerialStopBitsFrom(stopBits: stopBits);
}

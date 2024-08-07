// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/controller.dart';
import 'api/serial.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'frb_generated.io.dart'
    if (dart.library.js_interop) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {}

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.1.0';

  @override
  int get rustContentHash => 1369680863;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_bit',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Stream<String> crateApiControllerControllerCreateStream(
      {required Controller that});

  Controller crateApiControllerControllerNew();

  void crateApiControllerControllerPush(
      {required Controller that, required int threadId, required String data});

  void crateApiControllerControllerSetNewThreadId(
      {required Controller that, required int threadId});

  DataBits crateApiSerialDataBitsFrom({required DataBits dataBits});

  FlowControl crateApiSerialFlowControlFrom({required FlowControl flowControl});

  List<SerialPortInfo> crateApiSerialListAvailablePorts();

  Parity crateApiSerialParityFrom({required Parity parity});

  SerialPortInfo crateApiSerialSerialPortInfoNew(
      {required String name,
      required int speed,
      required DataBits dataBits,
      required Parity parity,
      required StopBits stopBits,
      required FlowControl flowControl});

  StopBits crateApiSerialStopBitsFrom({required StopBits stopBits});

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_Controller;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_Controller;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_ControllerPtr;
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Stream<String> crateApiControllerControllerCreateStream(
      {required Controller that}) {
    final streamSink = RustStreamSink<String>();
    handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
            that, serializer);
        sse_encode_StreamSink_String_Sse(streamSink, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 1)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiControllerControllerCreateStreamConstMeta,
      argValues: [that, streamSink],
      apiImpl: this,
    ));
    return streamSink.stream;
  }

  TaskConstMeta get kCrateApiControllerControllerCreateStreamConstMeta =>
      const TaskConstMeta(
        debugName: "Controller_create_stream",
        argNames: ["that", "streamSink"],
      );

  @override
  Controller crateApiControllerControllerNew() {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 2)!;
      },
      codec: SseCodec(
        decodeSuccessData:
            sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiControllerControllerNewConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiControllerControllerNewConstMeta =>
      const TaskConstMeta(
        debugName: "Controller_new",
        argNames: [],
      );

  @override
  void crateApiControllerControllerPush(
      {required Controller that, required int threadId, required String data}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
            that, serializer);
        sse_encode_u_32(threadId, serializer);
        sse_encode_String(data, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 3)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiControllerControllerPushConstMeta,
      argValues: [that, threadId, data],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiControllerControllerPushConstMeta =>
      const TaskConstMeta(
        debugName: "Controller_push",
        argNames: ["that", "threadId", "data"],
      );

  @override
  void crateApiControllerControllerSetNewThreadId(
      {required Controller that, required int threadId}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
            that, serializer);
        sse_encode_u_32(threadId, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 4)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiControllerControllerSetNewThreadIdConstMeta,
      argValues: [that, threadId],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiControllerControllerSetNewThreadIdConstMeta =>
      const TaskConstMeta(
        debugName: "Controller_set_new_thread_id",
        argNames: ["that", "threadId"],
      );

  @override
  DataBits crateApiSerialDataBitsFrom({required DataBits dataBits}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_data_bits(dataBits, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 5)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_data_bits,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSerialDataBitsFromConstMeta,
      argValues: [dataBits],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSerialDataBitsFromConstMeta => const TaskConstMeta(
        debugName: "data_bits_from",
        argNames: ["dataBits"],
      );

  @override
  FlowControl crateApiSerialFlowControlFrom(
      {required FlowControl flowControl}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_flow_control(flowControl, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 6)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_flow_control,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSerialFlowControlFromConstMeta,
      argValues: [flowControl],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSerialFlowControlFromConstMeta =>
      const TaskConstMeta(
        debugName: "flow_control_from",
        argNames: ["flowControl"],
      );

  @override
  List<SerialPortInfo> crateApiSerialListAvailablePorts() {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 7)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_serial_port_info,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSerialListAvailablePortsConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSerialListAvailablePortsConstMeta =>
      const TaskConstMeta(
        debugName: "list_available_ports",
        argNames: [],
      );

  @override
  Parity crateApiSerialParityFrom({required Parity parity}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_parity(parity, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 8)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_parity,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSerialParityFromConstMeta,
      argValues: [parity],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSerialParityFromConstMeta => const TaskConstMeta(
        debugName: "parity_from",
        argNames: ["parity"],
      );

  @override
  SerialPortInfo crateApiSerialSerialPortInfoNew(
      {required String name,
      required int speed,
      required DataBits dataBits,
      required Parity parity,
      required StopBits stopBits,
      required FlowControl flowControl}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(name, serializer);
        sse_encode_u_32(speed, serializer);
        sse_encode_data_bits(dataBits, serializer);
        sse_encode_parity(parity, serializer);
        sse_encode_stop_bits(stopBits, serializer);
        sse_encode_flow_control(flowControl, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 9)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_serial_port_info,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSerialSerialPortInfoNewConstMeta,
      argValues: [name, speed, dataBits, parity, stopBits, flowControl],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSerialSerialPortInfoNewConstMeta =>
      const TaskConstMeta(
        debugName: "serial_port_info_new",
        argNames: [
          "name",
          "speed",
          "dataBits",
          "parity",
          "stopBits",
          "flowControl"
        ],
      );

  @override
  StopBits crateApiSerialStopBitsFrom({required StopBits stopBits}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_stop_bits(stopBits, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 10)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_stop_bits,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSerialStopBitsFromConstMeta,
      argValues: [stopBits],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSerialStopBitsFromConstMeta => const TaskConstMeta(
        debugName: "stop_bits_from",
        argNames: ["stopBits"],
      );

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_Controller => wire
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_Controller => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  Controller
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ControllerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Controller
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ControllerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Controller
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ControllerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Controller
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ControllerImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  RustStreamSink<String> dco_decode_StreamSink_String_Sse(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    throw UnimplementedError();
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  DataBits dco_decode_data_bits(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return DataBits.values[raw as int];
  }

  @protected
  FlowControl dco_decode_flow_control(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return FlowControl.values[raw as int];
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  List<SerialPortInfo> dco_decode_list_serial_port_info(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_serial_port_info).toList();
  }

  @protected
  Parity dco_decode_parity(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return Parity.values[raw as int];
  }

  @protected
  SerialPortInfo dco_decode_serial_port_info(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 6)
      throw Exception('unexpected arr length: expect 6 but see ${arr.length}');
    return SerialPortInfo.raw(
      name: dco_decode_String(arr[0]),
      speed: dco_decode_u_32(arr[1]),
      dataBits: dco_decode_data_bits(arr[2]),
      parity: dco_decode_parity(arr[3]),
      stopBits: dco_decode_stop_bits(arr[4]),
      flowControl: dco_decode_flow_control(arr[5]),
    );
  }

  @protected
  StopBits dco_decode_stop_bits(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return StopBits.values[raw as int];
  }

  @protected
  int dco_decode_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  BigInt dco_decode_usize(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  Controller
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ControllerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Controller
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ControllerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Controller
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ControllerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Controller
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ControllerImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  RustStreamSink<String> sse_decode_StreamSink_String_Sse(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ()');
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  DataBits sse_decode_data_bits(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_i_32(deserializer);
    return DataBits.values[inner];
  }

  @protected
  FlowControl sse_decode_flow_control(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_i_32(deserializer);
    return FlowControl.values[inner];
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  List<SerialPortInfo> sse_decode_list_serial_port_info(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <SerialPortInfo>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_serial_port_info(deserializer));
    }
    return ans_;
  }

  @protected
  Parity sse_decode_parity(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_i_32(deserializer);
    return Parity.values[inner];
  }

  @protected
  SerialPortInfo sse_decode_serial_port_info(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_name = sse_decode_String(deserializer);
    var var_speed = sse_decode_u_32(deserializer);
    var var_dataBits = sse_decode_data_bits(deserializer);
    var var_parity = sse_decode_parity(deserializer);
    var var_stopBits = sse_decode_stop_bits(deserializer);
    var var_flowControl = sse_decode_flow_control(deserializer);
    return SerialPortInfo.raw(
        name: var_name,
        speed: var_speed,
        dataBits: var_dataBits,
        parity: var_parity,
        stopBits: var_stopBits,
        flowControl: var_flowControl);
  }

  @protected
  StopBits sse_decode_stop_bits(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_i_32(deserializer);
    return StopBits.values[inner];
  }

  @protected
  int sse_decode_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint32();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.message, serializer);
  }

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          Controller self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ControllerImpl).frbInternalSseEncode(move: true), serializer);
  }

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          Controller self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ControllerImpl).frbInternalSseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          Controller self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ControllerImpl).frbInternalSseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerController(
          Controller self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ControllerImpl).frbInternalSseEncode(move: null), serializer);
  }

  @protected
  void sse_encode_StreamSink_String_Sse(
      RustStreamSink<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(
        self.setupAndSerialize(
            codec: SseCodec(
          decodeSuccessData: sse_decode_String,
          decodeErrorData: sse_decode_AnyhowException,
        )),
        serializer);
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_data_bits(DataBits self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_flow_control(FlowControl self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_list_serial_port_info(
      List<SerialPortInfo> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_serial_port_info(item, serializer);
    }
  }

  @protected
  void sse_encode_parity(Parity self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_serial_port_info(
      SerialPortInfo self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.name, serializer);
    sse_encode_u_32(self.speed, serializer);
    sse_encode_data_bits(self.dataBits, serializer);
    sse_encode_parity(self.parity, serializer);
    sse_encode_stop_bits(self.stopBits, serializer);
    sse_encode_flow_control(self.flowControl, serializer);
  }

  @protected
  void sse_encode_stop_bits(StopBits self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint32(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }
}

@sealed
class ControllerImpl extends RustOpaque implements Controller {
  // Not to be used by end users
  ControllerImpl.frbInternalDcoDecode(List<dynamic> wire)
      : super.frbInternalDcoDecode(wire, _kStaticData);

  // Not to be used by end users
  ControllerImpl.frbInternalSseDecode(BigInt ptr, int externalSizeOnNative)
      : super.frbInternalSseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_Controller,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_Controller,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_ControllerPtr,
  );

  Stream<String> createStream() =>
      RustLib.instance.api.crateApiControllerControllerCreateStream(
        that: this,
      );

  void push({required int threadId, required String data}) =>
      RustLib.instance.api.crateApiControllerControllerPush(
          that: this, threadId: threadId, data: data);

  void setNewThreadId({required int threadId}) =>
      RustLib.instance.api.crateApiControllerControllerSetNewThreadId(
          that: this, threadId: threadId);
}

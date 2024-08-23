import 'dart:async';
import 'package:bit/state_terminal.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/state_app.dart';
import 'package:bit/warning_dialogue.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class SettingsTab extends StatefulWidget {
  final int threadId;
  final AppState state;
  const SettingsTab({
    super.key,
    required this.state,
    required this.threadId,
  });
  @override
  State<SettingsTab> createState() => _CreateSettingsTabState();
}

class _CreateSettingsTabState extends State<SettingsTab> {
  String _nameSettingElement = "Port Name";
  final TextEditingController _speedController =
      TextEditingController(text: "9600");
  late TerminalState terminalState;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    terminalState = widget.state.getTerminalState(widget.threadId)!;
    _speedController.text = terminalState.getSettingsSpeed().toString();
  }

  @override
  void dispose() {
    _speedController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void warnIfConnected(BuildContext context, void Function() onAccept) {
    if (widget.state.globalSettings.getWarnings()) {
      if (terminalState.connected) {
        return showWarningDialog(
            state: widget.state,
            context: context,
            explanation:
                "You are still connected, if you accept this will disconnect and reconnect automatically!",
            onAccept: () {
              // Disconnect, make change, reconnect
              terminalState.disconnectIfNotDisconnected();
              onAccept();
              terminalState.connectIfNotConnected();
            },
            onCancel: () => {
                  //Ignore change
                });
      } else {
        onAccept();
      }
    } else {
      // If warnings are disabled we do nothing.
      if (terminalState.connected) {
        terminalState.disconnectIfNotDisconnected();
        onAccept();
        terminalState.connectIfNotConnected();
      } else {
        onAccept();
      }
    }
  }

  String validateSerialPortInfoName(List<SerialPortInfo> serialPortInfoList) {
    // The name loaded from disk may no longer be connected so we need to check that
    String name = terminalState.getSettingsName();
    // If name from disk still exists on device then we choose that so it "remembers"
    // which com port it was on. It cannot remember the device name for obvious reasons.
    // So if the user moves that around or the OS reassigns names on startup there
    // is nothing we can do about that.
    for (SerialPortInfo serialPortInfo in serialPortInfoList) {
      if (name == serialPortInfo.name) {
        return name;
      }
    }
    // If name from disk does not exist.
    try {
      name = serialPortInfoList[0].name;
      return name;
    } on RangeError {
      log("No valid ports available."); // debug log here instead
      name = "N/A";
      return name;
    }
  }

  void _onChangedHandlerSpeed(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      log("onEditingComplete Triggered: $value");
      try {
        warnIfConnected(context, () {
          setState(() {
            var v = int.parse(value);
            terminalState.setSettingsSpeed(v);
          });
        });
      } on FormatException {
        setState(() {});
        log("Invalid Speed");
      }
    });
  }

  GridView settingsGrid() {
    List<SerialPortInfo> serialPortInfo = listAvailablePorts();
    List<DropdownMenuItem<String>> items9 = serialPortInfo.map((v) {
      return DropdownMenuItem<String>(value: v.name, child: Text(v.name));
    }).toList();

    _nameSettingElement = "No Ports";
    String nameStr = validateSerialPortInfoName(serialPortInfo);
    var name = DropdownButton(
        value: nameStr,
        items: items9,
        hint: Text(_nameSettingElement),
        onChanged: (name) {
          warnIfConnected(context, () {
            setState(() {
              log("_name set to $name");
              terminalState.setSettingsName(name!);
            });
          });
        });
    var nameGroup = Column(
      children: [const Text("Name"), name],
    );

    int speed = terminalState.getSettingsSpeed();
    TextField speedTextField;
    InputDecoration decoration;
    try {
      speed = int.parse(_speedController.text);
      decoration = const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Speed', // Set the error text color
        // Other properties...
      );
    } on FormatException {
      decoration = const InputDecoration(
        border: OutlineInputBorder(),
        errorText: "Invalid Number",
        labelText: 'Speed', // Set the error text color
        // Other properties...
      );
    }

    speedTextField = TextField(
        controller: _speedController,
        // onChanged: (String value) {
        //   setState(() {});
        // },
        onChanged: (value) {
          // Timer only triggers after a 250 ms delay
          _onChangedHandlerSpeed(value);
        },
        decoration: decoration);

    var speedGroup = Column(
      children: [const Text("Speed"), speedTextField],
    );

    DataBits dataBitsInput = terminalState.getSettingsDataBits();
    List<DropdownMenuItem<DataBits>> items = DataBits.values.map((v) {
      return DropdownMenuItem<DataBits>(value: v, child: Text(v.name));
    }).toList();
    var dataBits = DropdownButton(
        hint: const Text('Data Bits'),
        value: dataBitsInput,
        items: items,
        onChanged: (dataBit) {
          log("_dataBits set to $dataBit");
          warnIfConnected(context, () {
            setState(() {
              terminalState.setSettingsDataBits(dataBit!);
            });
          });
        });
    var dataGroup = Column(
      children: [const Text("Databit"), dataBits],
    );

    StopBits stopBitStr = terminalState.getSettingsStopBits();
    List<DropdownMenuItem<StopBits>> items11 = StopBits.values.map((v) {
      return DropdownMenuItem<StopBits>(value: v, child: Text(v.name));
    }).toList();
    var stopBit = DropdownButton(
        hint: const Text('Stop Bits'),
        value: stopBitStr,
        items: items11,
        onChanged: (stopBit) {
          warnIfConnected(context, () {
            setState(() {
              log("_stopbit set to $stopBit");
              terminalState.setSettingsStopBits(stopBit!);
            });
          });
        });

    var stopGroup = Column(
      children: [const Text("Stopbit"), stopBit],
    );

    Parity parity = terminalState.getSettingsParity();

    List<DropdownMenuItem<Parity>> items2 = Parity.values.map((v) {
      return DropdownMenuItem<Parity>(value: v, child: Text(v.name));
    }).toList();
    var parityBtn = DropdownButton(
        hint: const Text('Parity'),
        value: parity,
        items: items2,
        onChanged: (parity) {
          warnIfConnected(context, () {
            setState(() {
              terminalState.setSettingsParity(parity!);
            });
          });
        });

    var parGroup = Column(
      children: [const Text("Parity"), parityBtn],
    );
    FlowControl flowControl = terminalState.getSettingsFlowControl();
    List<DropdownMenuItem<FlowControl>> items3 = FlowControl.values.map((v) {
      return DropdownMenuItem<FlowControl>(value: v, child: Text(v.name));
    }).toList();
    var flowControlBtn = DropdownButton(
        hint: const Text('Flow Control'),
        value: flowControl,
        items: items3,
        onChanged: (flowControl) {
          warnIfConnected(context, () {
            setState(() {
              terminalState.setSettingsFlowControl(flowControl!);
            });
          });
        });

    var flowGroup = Column(
      children: [const Text("Flow Control"), flowControlBtn],
    );

    var btn = ElevatedButton(
        onPressed: () {
          var s = SerialPortInfo(
              name: nameStr,
              speed: speed,
              dataBits: dataBitsInput,
              parity: parity,
              stopBits: stopBitStr,
              flowControl: flowControl);
          log("${s.name}, ${s.speed}, ${s.dataBits}, ${s.parity}, ${s.stopBits}, ${s.flowControl}");
        },
        child: const Text("log Port Information"));

    var grid = GridView.count(
      padding: const EdgeInsets.all(20),
      childAspectRatio: 5 / 2,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 20, // Adjust horizontal spacing
      crossAxisCount: 2,
      children: [
        nameGroup,
        speedGroup,
        dataGroup,
        parGroup,
        stopGroup,
        flowGroup,
        btn
      ],
    );
    return grid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(child: settingsGrid()),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:bit/state_terminal.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/state_app.dart';
import 'package:bit/warning_dialogue.dart';
import 'package:flutter/material.dart';

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
  String _name_setting_element = "Port Name";
  TextEditingController _speed_controller = TextEditingController(text: "9600");
  late TerminalState terminalState;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    terminalState = widget.state.getTerminalState(widget.threadId)!;
    _speed_controller.text = terminalState.getSettingsSpeed().toString();
  }

  @override
  void dispose() {
    _speed_controller.dispose();
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
    String _name = terminalState.getSettingsName();
    // If name from disk still exists on device then we choose that so it "remembers"
    // which com port it was on. It cannot remember the device name for obvious reasons.
    // So if the user moves that around or the OS reassigns names on startup there
    // is nothing we can do about that.
    for (SerialPortInfo serialPortInfo in serialPortInfoList) {
      if (_name == serialPortInfo.name) {
        return _name;
      }
    }
    // If name from disk does not exist.
    try {
      _name = serialPortInfoList[0].name;
      return _name;
    } on RangeError {
      print("No valid ports available."); // debug log here instead
      _name = "N/A";
      return _name;
    }
  }

  void _onChangedHandlerSpeed(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 250), () {
      print("onEditingComplete Triggered: $value");
      try {
        warnIfConnected(context, () {
          setState(() {
            var v = int.parse(value);
            terminalState.setSettingsSpeed(v);
          });
        });
      } on FormatException {
        setState(() {});
        print("Invalid Speed");
      }
    });
  }

  GridView settingsGrid() {
    List<SerialPortInfo> serialPortInfo = listAvailablePorts();
    List<DropdownMenuItem<String>> items9 = serialPortInfo.map((v) {
      return DropdownMenuItem<String>(value: v.name, child: Text(v.name));
    }).toList();

    _name_setting_element = "No Ports";
    String _name = validateSerialPortInfoName(serialPortInfo);
    var name = DropdownButton(
        value: _name,
        items: items9,
        hint: Text(_name_setting_element),
        onChanged: (name) {
          warnIfConnected(context, () {
            setState(() {
              print("_name set to $name");
              terminalState.setSettingsName(name!);
            });
          });
        });
    var name_group = Column(
      children: [Text("Name"), name],
    );

    int _speed = terminalState.getSettingsSpeed();
    TextField speed;
    InputDecoration decoration;
    try {
      _speed = int.parse(_speed_controller.text);
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

    speed = TextField(
        controller: _speed_controller,
        // onChanged: (String value) {
        //   setState(() {});
        // },
        onChanged: (value) {
          // Timer only triggers after a 250 ms delay
          _onChangedHandlerSpeed(value);
        },
        decoration: decoration);

    var speed_group = Column(
      children: [Text("Speed"), speed],
    );

    DataBits _dataBits = terminalState.getSettingsDataBits();
    List<DropdownMenuItem<DataBits>> items = DataBits.values.map((v) {
      return DropdownMenuItem<DataBits>(value: v, child: Text(v.name));
    }).toList();
    var dataBits = DropdownButton(
        hint: Text('Data Bits'),
        value: _dataBits,
        items: items,
        onChanged: (dataBit) {
          print("_dataBits set to $dataBit");
          warnIfConnected(context, () {
            setState(() {
              terminalState.setSettingsDataBits(dataBit!);
            });
          });
        });
    var data_group = Column(
      children: [Text("Databit"), dataBits],
    );

    StopBits _stopBit = terminalState.getSettingsStopBits();
    List<DropdownMenuItem<StopBits>> items11 = StopBits.values.map((v) {
      return DropdownMenuItem<StopBits>(value: v, child: Text(v.name));
    }).toList();
    var stopBit = DropdownButton(
        hint: Text('Stop Bits'),
        value: _stopBit,
        items: items11,
        onChanged: (stopBit) {
          warnIfConnected(context, () {
            setState(() {
              print("_stopbit set to $stopBit");
              terminalState.setSettingsStopBits(stopBit!);
            });
          });
        });

    var stop_group = Column(
      children: [Text("Stopbit"), stopBit],
    );

    Parity _parity = terminalState.getSettingsParity();

    List<DropdownMenuItem<Parity>> items2 = Parity.values.map((v) {
      return DropdownMenuItem<Parity>(value: v, child: Text(v.name));
    }).toList();
    var parity = DropdownButton(
        hint: Text('Parity'),
        value: _parity,
        items: items2,
        onChanged: (parity) {
          warnIfConnected(context, () {
            setState(() {
              terminalState.setSettingsParity(parity!);
            });
          });
        });

    var par_group = Column(
      children: [Text("Parity"), parity],
    );
    FlowControl _flowControl = terminalState.getSettingsFlowControl();
    List<DropdownMenuItem<FlowControl>> items3 = FlowControl.values.map((v) {
      return DropdownMenuItem<FlowControl>(value: v, child: Text(v.name));
    }).toList();
    var flowControl = DropdownButton(
        hint: Text('Flow Control'),
        value: _flowControl,
        items: items3,
        onChanged: (flowControl) {
          warnIfConnected(context, () {
            setState(() {
              terminalState.setSettingsFlowControl(flowControl!);
            });
          });
        });

    var flow_group = Column(
      children: [Text("Flow Control"), flowControl],
    );

    var btn = ElevatedButton(
        onPressed: () {
          var s = SerialPortInfo(
              name: _name,
              speed: _speed,
              dataBits: _dataBits,
              parity: _parity,
              stopBits: _stopBit,
              flowControl: _flowControl);
          print(
              "${s.name}, ${s.speed}, ${s.dataBits}, ${s.parity}, ${s.stopBits}, ${s.flowControl}");
        },
        child: Text("Print Port Information"));

    var grid = GridView.count(
      padding: const EdgeInsets.all(20),
      childAspectRatio: 5 / 2,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 20, // Adjust horizontal spacing
      crossAxisCount: 2,
      children: [
        name_group,
        speed_group,
        data_group,
        par_group,
        stop_group,
        flow_group,
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

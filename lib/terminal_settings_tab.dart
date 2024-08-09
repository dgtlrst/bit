import 'dart:ffi';

import 'package:bit/State_terminal.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/State_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'sidepanel.dart'; // side panel

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

  @override
  void initState() {
    super.initState();
    terminalState = widget.state.getTerminalState(widget.threadId)!;
  }

  GridView settingsGrid() {
    List<SerialPortInfo> serialPortInfo = listAvailablePorts();
    List<DropdownMenuItem<String>> items9 = serialPortInfo.map((v) {
      return DropdownMenuItem<String>(value: v.name, child: Text(v.name));
    }).toList();

    String _name = terminalState.settings.name;
    try {
      _name = serialPortInfo[0].name;
    } on RangeError catch (e) {
      print("No valid ports available."); // debug log here instead
      _name = "N/A";
      _name_setting_element = "No Ports";
    }

    var name = DropdownButton(
        value: _name,
        items: items9,
        hint: Text(_name_setting_element),
        onChanged: (name) {
          setState(() {
            print("_name set to $name");
            _name = name!;
            terminalState.settings.name = name!;
          });
        });
    var name_group = Column(
      children: [Text("Name"), name],
    );

    int _speed = terminalState.settings.speed;
    TextField speed;
    try {
      int.parse(_speed_controller.text);
      speed = TextField(
          controller: _speed_controller,
          onChanged: (value) {
            setState(() {
              try {
                setState(() {
                  _speed = int.parse(value);
                  print("_speed set to $_speed");
                });
              } on FormatException {
                print("Invalid Speed");
              }
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Speed', // Set the error text color
            // Other properties...
          ));
    } on FormatException {
      speed = TextField(
          controller: _speed_controller,
          onChanged: (value) {
            try {
              setState(() {
                terminalState.settings.speed = _speed;

                print("_speed set to $_speed");
              });
            } on FormatException {
              print("Invalid Speed");
            }
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            errorText: "Invalid Number",
            labelText: 'Speed', // Set the error text color
            // Other properties...
          ));
    }

    var speed_group = Column(
      children: [Text("Speed"), speed],
    );

    DataBits _dataBits = terminalState.settings.dataBits;
    List<DropdownMenuItem<DataBits>> items = DataBits.values.map((v) {
      return DropdownMenuItem<DataBits>(value: v, child: Text(v.name));
    }).toList();
    var dataBits = DropdownButton(
        hint: Text('Data Bits'),
        value: _dataBits,
        items: items,
        onChanged: (dataBit) {
          setState(() {
            print("_dataBits set to $dataBit");
            terminalState.settings.dataBits = dataBit!;
          });
        });
    var data_group = Column(
      children: [Text("Databit"), dataBits],
    );

    StopBits _stopBit = terminalState.settings.stopBits;
    List<DropdownMenuItem<StopBits>> items11 = StopBits.values.map((v) {
      return DropdownMenuItem<StopBits>(value: v, child: Text(v.name));
    }).toList();
    var stopBit = DropdownButton(
        hint: Text('Stop Bits'),
        value: _stopBit,
        items: items11,
        onChanged: (stopbit) {
          setState(() {
            print("_stopbit set to $stopbit");
            terminalState.settings.stopBits = stopbit!;
          });
        });

    var stop_group = Column(
      children: [Text("Stopbit"), stopBit],
    );

    Parity _parity = terminalState.settings.parity;

    List<DropdownMenuItem<Parity>> items2 = Parity.values.map((v) {
      return DropdownMenuItem<Parity>(value: v, child: Text(v.name));
    }).toList();
    var parity = DropdownButton(
        hint: Text('Parity'),
        value: _parity,
        items: items2,
        onChanged: (parity) {
          setState(() {
            terminalState.settings.parity = parity!;
          });
        });

    var par_group = Column(
      children: [Text("Parity"), parity],
    );
    FlowControl _flowControl = terminalState.settings.flowControl;
    List<DropdownMenuItem<FlowControl>> items3 = FlowControl.values.map((v) {
      return DropdownMenuItem<FlowControl>(value: v, child: Text(v.name));
    }).toList();
    var flowControl = DropdownButton(
        hint: Text('Flow Control'),
        value: _flowControl,
        items: items3,
        onChanged: (flowcontrol) {
          setState(() {
            terminalState.settings.flowControl = flowcontrol!;
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
    // define app colors
    const Color textFieldColor = Color.fromARGB(
        255, 23, 29, 35); // Slightly darker TextField background color
    const Color textFieldTextColor = Color.fromARGB(
        255, 200, 220, 224); // Slightly different TextField text color
    const Color mainTextColor = Color.fromARGB(
        255, 144, 168, 174); // Slightly different Main content text color
    return Column(
      children: [
        Expanded(
          child: Center(child: settingsGrid()),
        ),
      ],
    );
  }
}

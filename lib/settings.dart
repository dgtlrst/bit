import 'dart:ffi';

import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'sidepanel.dart'; // side panel

class Settings extends StatefulWidget {
  final AppState state;
  const Settings({super.key, required this.state});
  @override
  State<Settings> createState() => _CreateSettingsState();
}

class _CreateSettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('settings')),
      body: Row(
        children: [
          // main content
          SidePanel(SidePanelPage.settings, widget.state),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Text("No Buttons Yet"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:bit/State_terminal.dart';
import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:bit/State_app.dart';
import 'package:bit/terminal_IO_tab.dart';
import 'package:bit/terminal_settings_tab.dart';
import 'package:flutter/material.dart';

import 'sidepanel.dart'; // side panel

class Terminal extends StatefulWidget {
  final AppState state;
  final int threadId;
  const Terminal({super.key, required this.state, required this.threadId});
  @override
  State<Terminal> createState() => _CreateTerminalState();
}

class _CreateTerminalState extends State<Terminal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TerminalState terminalState;
  @override
  void initState() {
    super.initState();
    print("Creating Terminal with TerminalState threadId: ${widget.threadId}");
    terminalState = widget.state.getThreadAndCreateIfNotExist(widget.threadId);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    terminalState.inUse = false;
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [Text("IO"), Icon(Icons.settings)],
        ),
        Expanded(
            child: TabBarView(controller: _tabController, children: [
          TerminalIOTab(
            state: widget.state,
            threadId: widget.threadId,
          ),
          SettingsTab(
            state: widget.state,
            threadId: widget.threadId,
          )
        ]))
      ],
    );
  }
}

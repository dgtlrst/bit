import 'dart:async';

import 'package:bit/src/rust/api/controller.dart';
import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/src/rust/frb_generated.dart';
import 'package:bit/terminal_IO_tab.dart';
import 'package:bit/terminal_settings_tab.dart';
import 'package:flutter/material.dart';

import 'sidepanel.dart'; // side panel

class Terminal extends StatefulWidget {
  final Controller controller;
  final int threadId;
  const Terminal({super.key, required this.controller, required this.threadId});
  @override
  State<Terminal> createState() => _CreateTerminalState();
}

class _CreateTerminalState extends State<Terminal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> dataStore = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [Text("IO"), Text("Settings")],
        ),
        Expanded(
            child: TabBarView(controller: _tabController, children: [
          TerminalIOTab(
            controller: widget.controller,
            threadId: widget.threadId,
            dataStore: dataStore,
          ),
          SettingsTab()
        ]))
      ],
    );
  }
}

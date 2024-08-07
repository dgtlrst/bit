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
  late Stream<String> stream;
  late StreamSubscription<String> listener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    widget.controller.setNewThreadId(threadId: widget.threadId);
    stream = widget.controller.createStream().asBroadcastStream();
    listener = stream.listen(streamHandler());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void connect() {}

  void Function(String) streamHandler() {
    // We update the data regardless which tab we're in to ensure continuity.
    return (String data) {
      if (mounted) {
        dataStore.add(data);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [Text("IO"), Text("Settings")],
        ),
        Expanded(
            child: TabBarView(controller: _tabController, children: [
          TerminalIOTab(
            stream: stream,
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

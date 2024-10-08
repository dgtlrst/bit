import 'package:bit/state_terminal.dart';
import 'package:bit/state_app.dart';
import 'package:bit/terminal_io_tab.dart';
import 'package:bit/terminal_settings_tab.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

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
    log("Creating Terminal with TerminalState threadId: ${widget.threadId}");
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
          tabs: const [Text("IO"), Icon(Icons.settings)],
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

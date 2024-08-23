// This class owns all streams and connectors and other data for the UI
// so that the data can be continously updated without necessarily rebuilding the
// widget tree.

import 'dart:async';
import 'dart:collection';

import 'package:bit/state_globals.dart';
import 'package:bit/state_persistent_datastore.dart';
import 'package:bit/state_terminal.dart';

class AppState {
  final HashMap<int, TerminalState> _threads = HashMap();
  late GlobalSettings globalSettings;
  PersistentDataStore dataStore;
  AppState._create({required this.dataStore}) {
    globalSettings = GlobalSettings(dataStore);
  }

  /// Public factory
  static Future<AppState> create() async {
    // Call the private constructor
    var dataStore = await PersistentDataStore.create();
    var state = AppState._create(dataStore: dataStore);
    // Do initialization that requires async

    // Return the fully initialized object
    return state;
  }

  void newTerminalState(int threadId) {
    if (getTerminalState(threadId) != null) {
      throw Exception("This thread already exists");
    }
    // Returns threadId
    TerminalState terminal =
        TerminalState(threadId: threadId, dataStore: dataStore);
    // No need to check
    // Whether existing terminal in HashMap since we always increment by one
    // If a user maxes out a 64 bit integer that's on them.
    _threads.putIfAbsent(threadId, () => terminal);
  }

  void deleteTerminal(int threadId) {
    var thread = _threads[threadId];
    if (thread != null) {
      thread.disconnectIfNotDisconnected();
    } else {
      print("Terminal with Id: $threadId does not exist");
    }
    _threads.remove(threadId);
  }

  TerminalState? getTerminalState(int threadId) {
    return _threads[threadId];
  }

  TerminalState getThreadAndCreateIfNotExist(int threadId) {
    TerminalState? terminal = getTerminalState(threadId);
    if (terminal != null) {
      return terminal;
    } else {
      // If not yet returned create new thread
      newTerminalState(threadId);
      TerminalState state = getTerminalState(threadId)!;
      state.inUse = true;
      return state;
    }
  }
}

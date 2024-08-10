import 'package:bit/State_persistent_datastore.dart';
import 'package:json_annotation/json_annotation.dart';

enum Layout { oneByOne, oneByTwo, twoByOne, twoByTwo }

class GlobalSettings {
  final PersistentDataStore _dataStore;
  GlobalSettings(this._dataStore) {
    _warnings = _dataStore.loadGlobalWarnings();
    _layout = _dataStore.loadGlobalLayout();
  }
  bool _warnings = true;
  Layout _layout = Layout.oneByTwo;

  Layout getLayout() {
    return _layout;
  }

  void setLayout(Layout layout) {
    _layout = layout;
    // Intentionally not awaiting, will save eventually
    _dataStore.saveGlobalLayout(layout).catchError((e, s) {
      print("Failed to save Layout!: ${e.toString()}");
    });
  }

  bool getWarnings() {
    return _warnings;
  }

  void setWarnings(bool warnings) {
    _warnings = warnings;
    // Intentionally not awaiting, will save eventually
    _dataStore.saveGlobalWarnings(_warnings).catchError((e, s) {
      print("Failed to save Warnings!: ${e.toString()}");
    });
  }
}

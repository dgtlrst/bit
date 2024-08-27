import 'state_persistent_datastore.dart';

enum Layout {
  oneByOne,
  oneByTwo,
  twoByOne,
  twoByTwo;

  static Layout fromString(String stringValue) {
    return Layout.values.firstWhere(
      (status) => status.name == stringValue,
      orElse: () => throw ArgumentError('No matching Status for $stringValue'),
    );
  }
}

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
    _dataStore.saveGlobalLayout(layout);
  }

  bool getWarnings() {
    return _warnings;
  }

  void setWarnings(bool warnings) {
    _warnings = warnings;
    // Intentionally not awaiting, will save eventually
    _dataStore.saveGlobalWarnings(_warnings);
  }
}

import 'package:bit/src/rust/api/serial.dart';
import 'package:bit/state_globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentDataStore {
  // This is not guaranteed to persist to disk. This will persist on a best
  // effort basis. For critical data use something else.
  final SharedPreferencesWithCache _prefsWithCache;
  PersistentDataStore._create(this._prefsWithCache);

  static Future<SharedPreferencesWithCache> _createPrefsWithCache() async {
    SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
            cacheOptions: const SharedPreferencesWithCacheOptions());
    return prefsWithCache;
  }

  /// Public factory
  static Future<PersistentDataStore> create() async {
    // Call the private constructor
    SharedPreferencesWithCache prefsWithCache = await _createPrefsWithCache();
    var dataStore = PersistentDataStore._create(prefsWithCache);
    // Do initialization that requires async

    // Return the fully initialized object
    return dataStore;
  }

  void saveTerminalState(int threadId, SerialPortInfo serialPortInfo) {
    _prefsWithCache
        .setString("terminalState_$threadId", serialPortInfo.toJson()!)
        .catchError((e, s) {
      print("Failed to save terminalState!: ${e.toString()}");
    });
    ;
  }

  void saveGlobalWarnings(bool warnings) {
    // It saves when it saves
    _prefsWithCache.setBool("warnings", warnings).catchError((e, s) {
      print("Failed to save Warnings!: ${e.toString()}");
    });
    ;
  }

  void saveGlobalLayout(Layout layout) {
    // It saves when it saves
    _prefsWithCache
        .setString("layout", layout.name.toString())
        .catchError((e, s) {
      print("Failed to save Layout!: ${e.toString()}");
    });
  }

  bool loadGlobalWarnings() {
    bool defaultWarnings = true;
    bool? warnings;
    try {
      warnings = _prefsWithCache.getBool("warnings");
      if (warnings != null) {
        return warnings;
      } else {
        return defaultWarnings;
      }
    } catch (e) {
      // Value does not exist! Or Type is wrong. Use default true.
      warnings = defaultWarnings;
      return warnings;
    }
  }

  Layout loadGlobalLayout() {
    Layout defaultLayout = Layout.oneByOne;
    Layout? layout;
    try {
      String? result = _prefsWithCache.getString("layout");
      if (result == null) {
        return defaultLayout;
      } else {
        Layout layout = Layout.fromString(result);
        return layout;
      }
    } catch (e) {
      print(e);
      // layout does not exist! Or Type is wrong. Or could not cast! Use default oneByOne.
      return defaultLayout;
    }
  }

  SerialPortInfo loadTerminalState(int threadId) {
    SerialPortInfo defaultSerialPortInfo = SerialPortInfo(
        name: "",
        speed: 9600,
        dataBits: DataBits.eight,
        parity: Parity.none,
        stopBits: StopBits.one,
        flowControl: FlowControl.none);
    SerialPortInfo? serialPortInfo;
    try {
      String? result = _prefsWithCache.getString("terminalState_$threadId");
      if (result != null) {
        serialPortInfo = SerialPortInfo.fromJson(json: result);
        if (serialPortInfo != null) {
          print("Loaded SerialPortInfo from Disk");
          return serialPortInfo;
        } else {
          print("Loading SerialPortInfo was null, using Default");

          return defaultSerialPortInfo;
        }
      } else {
        print("Loading SerialPortInfo String was null, using Default");
        return defaultSerialPortInfo;
      }
    } catch (e) {
      print(e);
      print("Loading SerialPortInfo errored, using Default");
      // layout does not exist! Or Type is wrong. Or could not cast! Use default oneByOne.
      return defaultSerialPortInfo;
    }
  }
}

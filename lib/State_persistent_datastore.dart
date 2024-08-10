import 'package:bit/State_globals.dart';
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

  saveGlobalWarnings(bool warnings) {
    // It saves when it saves
    _prefsWithCache.setBool("warnings", warnings).catchError((e, s) {
      print("Failed to save Layout!: ${e.toString()}");
    });
    ;
  }

  saveGlobalLayout(Layout layout) {
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
}

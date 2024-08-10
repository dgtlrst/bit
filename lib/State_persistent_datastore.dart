import 'package:bit/State_globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentDataStore {
  // This is not guaranteed to persist to disk. This will persist on a best
  // effort basis. For critical data use something else.
  late SharedPreferencesWithCache prefsWithCache;
  PersistentDataStore._create();

  Future<SharedPreferencesWithCache> _createPrefsWithCache() async {
    SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
            cacheOptions: const SharedPreferencesWithCacheOptions());
    return prefsWithCache;
  }

  /// Public factory
  static Future<PersistentDataStore> create() async {
    // Call the private constructor
    var dataStore = PersistentDataStore._create();
    await dataStore._createPrefsWithCache();
    // Do initialization that requires async

    // Return the fully initialized object
    return dataStore;
  }

  saveGlobalWarnings(bool warnings) {
    // It saves when it saves
    prefsWithCache.setBool("warnings", warnings);
  }

  saveGlobalLayout(Layout layout) {
    // It saves when it saves
    prefsWithCache.setString("layout", layout.toString());
  }

  loadGlobalWarnings() {
    bool warnings;
    try {
      warnings = prefsWithCache.getBool("warnings")!;
      return warnings;
    } catch (e) {
      // Value does not exist! Or Type is wrong. Use default true.
      warnings = true;
      return warnings;
    }
  }

  loadGlobalLayout() {
    Layout layout;
    try {
      layout = prefsWithCache.get("layout")! as Layout;
      return layout;
    } catch (e) {
      print(e);
      // layout does not exist! Or Type is wrong. Or could not cast! Use default oneByOne.
      layout = Layout.oneByOne;
      return layout;
    }
  }
}

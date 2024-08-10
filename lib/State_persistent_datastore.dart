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

  saveGlobalWarnings(bool warnings) async {}
  saveGlobalLayout(Layout layout) async {}
  loadGlobalWarnings() {
    return false;
  }

  loadGlobalLayout() {
    return Layout.oneByOne;
  }
}

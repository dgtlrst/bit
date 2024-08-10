import 'package:bit/State_globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentDataStore {
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
  GlobalSettings loadGlobalSettings() {
    throw Exception("Not implemented yet");
  }
}

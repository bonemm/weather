import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IStoredDataProvider {
  Future<String?> getFavoriteList();
  Future<bool> setFavoriteList(String? favorites);
}

class StoredDataProvider implements IStoredDataProvider {
  // Bumped from "favorites_with_weather_key" when migrating to Open-Meteo:
  // the stored entry shape changed (weather_code/is_day instead of an OWM icon
  // string), so old data is intentionally dropped rather than migrated.
  static const _favoritesInfoKey = "favorites_with_weather_v2_key";

  @override
  Future<String?> getFavoriteList() => _getItem(_favoritesInfoKey);

  @override
  Future<bool> setFavoriteList(String? favorites) => _setItem(key: _favoritesInfoKey, item: favorites);

  Future<bool> _setItem({
    required final String key,
    required final String? item,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? '');
    return result;
  }

  Future<String?> _getItem(
    final String key,
  ) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}

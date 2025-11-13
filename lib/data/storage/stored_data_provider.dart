import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IStoredDataProvider {
  Future<String?> getFavoriteList();
  Future<bool> setFavoriteList(String? favorites);
}

class StoredDataProvider implements IStoredDataProvider {
  static const _favoritesInfoKey = "favorites_with_weather_key";

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

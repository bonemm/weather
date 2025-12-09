import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepoitory {
  static const String _themeKey = 'theme_mode';

  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }
}

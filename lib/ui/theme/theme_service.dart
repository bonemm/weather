import 'package:flutter/material.dart';
import 'package:weather/ui/settings/settings_repoitory.dart';
import 'themes.dart';

enum ThemeType { light, dark }

class ThemeService extends ChangeNotifier {
  ThemeType _currentTheme = ThemeType.light;
  final SettingsRepoitory settingsRepoitory;
  ThemeService(this.settingsRepoitory) {
    _loadTheme(settingsRepoitory);
  }

  ThemeType get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case ThemeType.light:
        return AppThemes.lightTheme;
      case ThemeType.dark:
        return AppThemes.darkTheme;
    }
  }

  bool get isDarkMode => _currentTheme == ThemeType.dark;

  Future<void> _loadTheme(SettingsRepoitory repo) async {
    final savedTheme = await settingsRepoitory.getTheme();
    if (savedTheme != null) {
      _currentTheme = ThemeType.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeType.light,
      );
      notifyListeners();
    }
  }

  void setTheme(ThemeType theme) {
    _currentTheme = theme;
    notifyListeners();
    _saveTheme();
  }

  void toggleTheme() {
    _currentTheme = _currentTheme == ThemeType.light ? ThemeType.dark : ThemeType.light;
    notifyListeners();
    _saveTheme();
  }

  Future<void> _saveTheme() async {
    settingsRepoitory.saveTheme(_currentTheme.toString());
  }
}

import 'package:flutter/material.dart';
import 'package:weather/ui/settings/settings_repoitory.dart';

/// Holds the app's selected language and persists it. Mirrors [ThemeService]:
/// a [ChangeNotifier] that the root `MaterialApp` listens to so a language
/// change rebuilds the whole UI.
class LocaleService extends ChangeNotifier {
  static const supportedLanguageCodes = ['en', 'ru'];
  static const _defaultLanguageCode = 'en';

  final SettingsRepoitory _settingsRepository;
  Locale _locale = const Locale(_defaultLanguageCode);

  LocaleService(this._settingsRepository) {
    _loadLocale();
  }

  Locale get locale => _locale;

  /// Language code (e.g. `en`, `ru`) for passing to APIs that accept a locale.
  String get languageCode => _locale.languageCode;

  Future<void> _loadLocale() async {
    final saved = await _settingsRepository.getLanguage();
    if (saved != null && supportedLanguageCodes.contains(saved)) {
      _locale = Locale(saved);
      notifyListeners();
    }
  }

  void setLanguage(String languageCode) {
    if (!supportedLanguageCodes.contains(languageCode) || languageCode == _locale.languageCode) {
      return;
    }
    _locale = Locale(languageCode);
    notifyListeners();
    _settingsRepository.saveLanguage(languageCode);
  }
}

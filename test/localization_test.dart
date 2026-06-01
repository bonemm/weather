import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/l10n/app_localizations.dart';
import 'package:weather/utils/weather_icon_mapper.dart';

/// Pumps a minimal app in [locale] and returns the active AppLocalizations.
Future<AppLocalizations> pumpAt(WidgetTester tester, Locale locale) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        l10n = AppLocalizations.of(context);
        return Text(l10n.appTitle);
      }),
    ),
  );
  return l10n;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  testWidgets('English UI strings resolve', (tester) async {
    final l10n = await pumpAt(tester, const Locale('en'));
    expect(l10n.appTitle, 'Weather');
    expect(l10n.tenDayForecast, '10-day forecast');
    expect(l10n.feelsLike, 'feels like');
    expect(find.text('Weather'), findsOneWidget);
  });

  testWidgets('Russian UI strings resolve', (tester) async {
    final l10n = await pumpAt(tester, const Locale('ru'));
    expect(l10n.appTitle, 'Погода');
    expect(l10n.tenDayForecast, 'Прогноз на 10 дней');
    expect(l10n.feelsLike, 'ощущается как');
    expect(l10n.settingsTitle, 'Настройки');
    expect(find.text('Погода'), findsOneWidget);
  });

  test('WMO condition descriptions localize', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final ru = lookupAppLocalizations(const Locale('ru'));
    expect(descriptionForWeatherCode(0, en), 'Clear sky');
    expect(descriptionForWeatherCode(0, ru), 'Ясно');
    expect(descriptionForWeatherCode(61, en), 'Rain');
    expect(descriptionForWeatherCode(61, ru), 'Дождь');
    expect(descriptionForWeatherCode(95, ru), 'Гроза');
  });

  test('Weekday names format per locale (DateFormat.EEEE)', () {
    final monday = DateTime(2026, 6, 1); // a Monday
    expect(DateFormat.EEEE('en').format(monday), 'Monday');
    expect(DateFormat.EEEE('ru').format(monday), 'понедельник');
  });
}

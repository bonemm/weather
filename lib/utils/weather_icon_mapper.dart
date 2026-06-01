import 'package:flutter/material.dart';
import 'package:weather/l10n/app_localizations.dart';

class _IconData extends IconData {
  const _IconData(super.codePoint)
      : super(
          fontFamily: 'WeatherIcons',
        );
}

/// Exposes specific weather icons.
/// hex values and ttf file from https://erikflowers.github.io/weather-icons/
class WeatherIcons {
  static const IconData clearDay = _IconData(0xf00d);
  static const IconData clearNight = _IconData(0xf02e);

  static const IconData fewCloudsDay = _IconData(0xf002);
  static const IconData fewCloudsNight = _IconData(0xf081);

  static const IconData cloudsDay = _IconData(0xf07d);
  static const IconData cloudsNight = _IconData(0xf080);

  static const IconData showerRainDay = _IconData(0xf009);
  static const IconData showerRainNight = _IconData(0xf029);

  static const IconData rainDay = _IconData(0xf008);
  static const IconData rainNight = _IconData(0xf028);

  static const IconData thunderStormDay = _IconData(0xf010);
  static const IconData thunderStormNight = _IconData(0xf03b);

  static const IconData snowDay = _IconData(0xf00a);
  static const IconData snowNight = _IconData(0xf02a);

  static const IconData mistDay = _IconData(0xf003);
  static const IconData mistNight = _IconData(0xf04a);
}

/// Maps an Open-Meteo WMO weather code to a weather icon.
///
/// Code groups follow the WMO table documented at https://open-meteo.com/en/docs:
///   0           clear sky
///   1, 2        mainly clear / partly cloudy
///   3           overcast
///   45, 48      fog
///   51-57       drizzle (incl. freezing)
///   61-67       rain (incl. freezing)
///   71-77       snow fall / grains
///   80-82       rain showers
///   85, 86      snow showers
///   95-99       thunderstorm (incl. with hail)
IconData iconForWeatherCode(int code, {required bool isDay}) {
  switch (code) {
    case 0:
      return isDay ? WeatherIcons.clearDay : WeatherIcons.clearNight;
    case 1:
    case 2:
      return isDay ? WeatherIcons.fewCloudsDay : WeatherIcons.fewCloudsNight;
    case 3:
      return isDay ? WeatherIcons.cloudsDay : WeatherIcons.cloudsNight;
    case 45:
    case 48:
      return isDay ? WeatherIcons.mistDay : WeatherIcons.mistNight;
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 80:
    case 81:
    case 82:
      return isDay ? WeatherIcons.showerRainDay : WeatherIcons.showerRainNight;
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
      return isDay ? WeatherIcons.rainDay : WeatherIcons.rainNight;
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return isDay ? WeatherIcons.snowDay : WeatherIcons.snowNight;
    case 95:
    case 96:
    case 99:
      return isDay ? WeatherIcons.thunderStormDay : WeatherIcons.thunderStormNight;
    default:
      return isDay ? WeatherIcons.clearDay : WeatherIcons.clearNight;
  }
}

/// Localized short description for an Open-Meteo WMO weather code.
String descriptionForWeatherCode(int code, AppLocalizations l10n) {
  switch (code) {
    case 0:
      return l10n.weatherClearSky;
    case 1:
      return l10n.weatherMainlyClear;
    case 2:
      return l10n.weatherPartlyCloudy;
    case 3:
      return l10n.weatherOvercast;
    case 45:
    case 48:
      return l10n.weatherFog;
    case 51:
    case 53:
    case 55:
      return l10n.weatherDrizzle;
    case 56:
    case 57:
      return l10n.weatherFreezingDrizzle;
    case 61:
    case 63:
    case 65:
      return l10n.weatherRain;
    case 66:
    case 67:
      return l10n.weatherFreezingRain;
    case 71:
    case 73:
    case 75:
      return l10n.weatherSnow;
    case 77:
      return l10n.weatherSnowGrains;
    case 80:
    case 81:
    case 82:
      return l10n.weatherRainShowers;
    case 85:
    case 86:
      return l10n.weatherSnowShowers;
    case 95:
      return l10n.weatherThunderstorm;
    case 96:
    case 99:
      return l10n.weatherThunderstormHail;
    default:
      return '';
  }
}

import 'package:flutter/material.dart';
import 'package:weather/di/dependencies_scope.dart';
import 'package:weather/l10n/app_localizations.dart';
import 'package:weather/utils/weather_icon_mapper.dart';

class TemperatureSpace extends StatelessWidget {
  const TemperatureSpace({
    super.key,
    required this.temp,
    required this.feelsLike,
    required this.weatherCode,
    required this.isDay,
  });

  final String temp;
  final String feelsLike;
  final int weatherCode;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Column(
        children: [
          Expanded(flex: 3, child: DayTemperature(temperature: temp, weatherCode: weatherCode, isDay: isDay)),
          Divider(color: Colors.blueGrey),
          Expanded(flex: 2, child: FeelLikeTemperature(flTemp: feelsLike)),
        ],
      ),
    );
  }
}

class DayTemperature extends StatelessWidget {
  const DayTemperature({super.key, required this.temperature, required this.weatherCode, required this.isDay});

  final String temperature;
  final int weatherCode;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    var themeService = DependenciesScope.of(context).themeService;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Temp(temp: temperature),
        Expanded(
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconForWeatherCode(weatherCode, isDay: isDay),
                size: 50,
                color: themeService.isDarkMode ? Colors.white : Colors.black,
              ),
              _ConditionText(
                text: descriptionForWeatherCode(weatherCode, AppLocalizations.of(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Weather condition label that wraps to two lines and only scales down when
/// the text still overflows that height (handles longer locales like Russian).
class _ConditionText extends StatelessWidget {
  const _ConditionText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }
}

class Temp extends StatelessWidget {
  const Temp({super.key, required this.temp});
  final String temp;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          temp,
          style: TextStyle(fontSize: 100, fontWeight: FontWeight.w200),
        ),
        Text(
          '°',
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.w200),
        ),
      ],
    );
  }
}

class FeelLikeTemperature extends StatelessWidget {
  const FeelLikeTemperature({
    super.key,
    required this.flTemp,
  });

  final String flTemp;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$flTemp°',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w200),
              ),
            ],
          ),
          Text(AppLocalizations.of(context).feelsLike),
        ],
      ),
    );
  }
}

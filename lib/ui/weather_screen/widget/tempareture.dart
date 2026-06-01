import 'dart:math' show pi;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:weather/l10n/app_localizations.dart';
import 'package:weather/utils/weather_icon_mapper.dart';

/// Current-weather block that morphs as the screen scrolls.
///
/// [t] is the collapse progress (0 = expanded, 1 = collapsed). The same
/// elements are animated by [t] rather than swapped:
///  - the divider rotates 0deg -> 90deg and shortens (long horizontal -> short
///    vertical);
///  - "feels like" travels diagonally from below-center to center-right;
///  - the temperature slides from center toward the left to make room.
class TemperatureSpace extends StatelessWidget {
  const TemperatureSpace({
    super.key,
    required this.temp,
    required this.feelsLike,
    required this.weatherCode,
    required this.isDay,
    this.t = 0,
  });

  final String temp;
  final String feelsLike;
  final int weatherCode;
  final bool isDay;
  final double t;

  @override
  Widget build(BuildContext context) {
    final p = t.clamp(0.0, 1.0);

    return SizedBox(
      width: 300,
      height: lerpDouble(280, 120, p),
      child: Stack(
        children: [
          // Temperature + icon/label: top-center when expanded, just slides
          // left along the top edge as it collapses (no downward motion).
          Align(
            alignment: Alignment.lerp(Alignment.topCenter, Alignment.topLeft, p)!,
            child: _DayTemperature(temperature: temp, weatherCode: weatherCode, isDay: isDay, t: p),
          ),

          // Divider: horizontal across the middle when expanded, rotates the
          // other way (counter-clockwise) to a short vertical bar up on the
          // right when collapsed.
          Align(
            alignment: Alignment.lerp(Alignment.center, const Alignment(0.35, -0.55), p)!,
            child: Transform.rotate(
              angle: -p * pi / 2,
              child: SizedBox(
                width: lerpDouble(240, 60, p),
                child: const Divider(height: 1),
              ),
            ),
          ),

          // "Feels like": below-center when expanded, travels diagonally up to
          // the top-right, on the same line as the temperature.
          Align(
            alignment: Alignment.lerp(Alignment.bottomCenter, const Alignment(1.0, -0.55), p)!,
            child: _FeelsLike(flTemp: feelsLike, t: p),
          ),
        ],
      ),
    );
  }
}

/// Big temperature value + weather icon and condition label. Sizes shrink with [t].
class _DayTemperature extends StatelessWidget {
  const _DayTemperature({
    required this.temperature,
    required this.weatherCode,
    required this.isDay,
    required this.t,
  });

  final String temperature;
  final int weatherCode;
  final bool isDay;
  final double t;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Temp(temp: temperature, t: t),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconForWeatherCode(weatherCode, isDay: isDay),
              size: lerpDouble(50, 30, t),
            ),
            SizedBox(height: lerpDouble(8, 2, t)),
            _ConditionText(
              text: descriptionForWeatherCode(weatherCode, AppLocalizations.of(context)),
              fontSize: lerpDouble(20, 13, t)!,
            ),
          ],
        ),
      ],
    );
  }
}

/// Weather condition label that wraps to two lines and only scales down when
/// the text still overflows that height (handles longer locales like Russian).
class _ConditionText extends StatelessWidget {
  const _ConditionText({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 130),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: fontSize),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}

class _Temp extends StatelessWidget {
  const _Temp({required this.temp, required this.t});

  final String temp;
  final double t;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.displayLarge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          temp,
          style: base?.copyWith(fontSize: lerpDouble(100, 56, t)),
        ),
        Text(
          '°',
          style: base?.copyWith(fontSize: lerpDouble(70, 38, t)),
        ),
      ],
    );
  }
}

class _FeelsLike extends StatelessWidget {
  const _FeelsLike({required this.flTemp, required this.t});

  final String flTemp;
  final double t;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$flTemp°',
          style: textTheme.displayLarge?.copyWith(fontSize: lerpDouble(60, 30, t)),
        ),
        Text(
          AppLocalizations.of(context).feelsLike,
          style: textTheme.bodyMedium?.copyWith(fontSize: lerpDouble(14, 11, t)),
        ),
      ],
    );
  }
}

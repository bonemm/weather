import 'package:flutter/material.dart';
import 'package:weather/di/dependencies_scope.dart';

class TemperatureSpace extends StatelessWidget {
  const TemperatureSpace({super.key, required this.temp, required this.feelsLike, required this.weatherText});

  final String temp;
  final String feelsLike;
  final String weatherText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Column(
        children: [
          Expanded(flex: 2, child: DayTemperature(temperature: temp, weatherText: weatherText)),
          Divider(color: Colors.blueGrey),
          Expanded(flex: 1, child: FeelLikeTemperature(flTemp: feelsLike)),
        ],
      ),
    );
  }
}

class DayTemperature extends StatelessWidget {
  const DayTemperature({super.key, required this.temperature, required this.weatherText});

  final String temperature;
  final String weatherText;

  @override
  Widget build(BuildContext context) {
    var themeService = DependenciesScope.of(context).themeService;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Temp(temp: temperature),
        Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/sunny.png',
              width: 60,
              color: themeService.isDarkMode ? Colors.white : Colors.black,
            ),
            Text(
              weatherText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
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
          Text('feels like'),
        ],
      ),
    );
  }
}

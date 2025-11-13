import 'package:flutter/material.dart';

class TemperatureSpace extends StatelessWidget {
  const TemperatureSpace({super.key, required this.temp, required this.feelsLike});

  final String temp;
  final String feelsLike;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFA5C8D1), borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          children: [
            Expanded(flex: 2, child: DayTemperature(temperature: temp)),
            Divider(
              color: Colors.blueGrey,
            ),
            Expanded(flex: 1, child: FeelLikeTemperature(flTemp: feelsLike)),
          ],
        ),
      ),
    );
  }
}

class DayTemperature extends StatelessWidget {
  const DayTemperature({
    super.key,
    required this.temperature,
  });

  final String temperature;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$temperature°',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
          ),
        ],
      ),
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
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
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

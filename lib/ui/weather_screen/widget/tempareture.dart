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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TempTest(temp: temperature),
        Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/sunny.png',
              width: 60,
            ),
            Text(
              'Sunny',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}

class TempTest extends StatelessWidget {
  const TempTest({super.key, required this.temp});
  final String temp;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        child: Text(
          temp,
          style: TextStyle(fontSize: 110, fontWeight: FontWeight.w200),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 60, bottom: 40),
          child: Text(
            '°',
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.w200),
          ),
        ),
      )
    ]);
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

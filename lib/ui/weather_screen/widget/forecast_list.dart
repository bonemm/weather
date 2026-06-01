import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/utils/weather_icon_mapper.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({super.key, required this.forecast});

  final List<ForecastEntityItem> forecast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 18),
          itemBuilder: (_, index) => WeekDayWeatherCard(
            date: forecast[index].date,
            dayTemp: forecast[index].dayTemp,
            nightTemp: forecast[index].nightTemp,
            weatherCode: forecast[index].weatherCode,
          ),
          separatorBuilder: (_, index) => const Divider(),
          itemCount: forecast.length,
        ),
        SizedBox(
          height: 200,
        )
      ],
    );
  }
}

class WeekDayWeatherCard extends StatelessWidget {
  const WeekDayWeatherCard({
    super.key,
    required this.date,
    required this.dayTemp,
    required this.nightTemp,
    required this.weatherCode,
  });

  final DateTime date;
  final String dayTemp;
  final String nightTemp;
  final int weatherCode;
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final dayOfWeek = DateFormat.EEEE(Localizations.localeOf(context).toString()).format(date);
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Text(dayOfWeek, style: textStyle),
          Spacer(),
          Icon(
            // Daily forecast has no day/night split; always show the day icon.
            iconForWeatherCode(weatherCode, isDay: true),
            size: 18,
          ),
          SizedBox(width: 15),
          Text('$dayTemp°/$nightTemp°', style: textStyle),
        ],
      ),
    );
  }
}

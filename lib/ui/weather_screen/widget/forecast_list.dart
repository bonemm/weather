import 'package:flutter/material.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/di/dependencies_scope.dart';
import 'package:weather/utils/weather_icon_mapper.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({super.key, required this.forecast});

  final List<ForecastEntityItem> forecast;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 18),
        itemBuilder: (_, index) => WeekDayWeatherCard(
          dayOfWeek: forecast[index].dayOfWeek,
          dayTemp: forecast[index].dayTemp,
          nightTemp: forecast[index].nightTemp,
          iconCode: forecast[index].iconCode,
        ),
        separatorBuilder: (_, index) => Divider(
          color: Colors.blueGrey,
          thickness: 1.0,
        ),
        itemCount: forecast.length,
      ),
    );
  }
}

class WeekDayWeatherCard extends StatelessWidget {
  const WeekDayWeatherCard({
    super.key,
    required this.dayOfWeek,
    required this.dayTemp,
    required this.nightTemp,
    required this.iconCode,
  });

  final String dayOfWeek;
  final String dayTemp;
  final String nightTemp;
  final String iconCode;
  @override
  Widget build(BuildContext context) {
    var themeService = DependenciesScope.of(context).themeService;
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Text(dayOfWeek),
          Spacer(),
          Icon(
            getIconData(iconCode),
            size: 18,
            color: themeService.isDarkMode ? Colors.white : Colors.black87,
          ),
          SizedBox(width: 15),
          Text('$dayTemp°/$nightTemp°'),
        ],
      ),
    );
  }
}

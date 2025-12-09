import 'dart:math';

import 'package:weather/data/network/models/forecast_response_dto.dart';
import 'package:weather/data/network/models/weather_response_dto.dart';

const days = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class WeatherEntity {
  final String locationName;
  final String countryCode;
  final String temperature;
  final String feelsLike;
  final String weatherText;

  const WeatherEntity(
      {required this.temperature,
      required this.feelsLike,
      required this.locationName,
      required this.countryCode,
      required this.weatherText});

  factory WeatherEntity.fromWeatherDto(WeatherResponseDto weatherResponseDto) => WeatherEntity(
      temperature: weatherResponseDto.weather.temp.round().toString(),
      feelsLike: weatherResponseDto.weather.feelsLike.round().toString(),
      countryCode: weatherResponseDto.sys.country,
      locationName: weatherResponseDto.name,
      weatherText: weatherResponseDto.weatherList.first.main);
}

class ForecstEntity {
  final List<ForecastEntityItem> forecast;

  const ForecstEntity({required this.forecast});

  factory ForecstEntity.fromForecastResponse(ForecastResponseDto forecastResponse) {
    int nightTemp = 1000;
    int dayTemp = -1000;
    String iconCode = '01d';
    final List<ForecastEntityItem> forecastData = [];

    for (int i = 0; i < forecastResponse.list.length - 1; i++) {
      var currentTime = DateTime.fromMillisecondsSinceEpoch(
        forecastResponse.list[i].dt.toInt() * 1000,
      );
      var nextTime = DateTime.fromMillisecondsSinceEpoch(
        forecastResponse.list[i + 1].dt.toInt() * 1000,
      );
      if (currentTime.day == nextTime.day) {
        if (currentTime.hour >= 0 && currentTime.hour <= 6) {
          nightTemp = min(nightTemp, forecastResponse.list[i].main.tempMin.round());
        } else {
          if (dayTemp != max(dayTemp, forecastResponse.list[i].main.tempMax.round())) {
            iconCode = forecastResponse.list[i].weather.first.icon;
          }
          dayTemp = max(dayTemp, forecastResponse.list[i].main.tempMax.round());
        }
      } else {
        if (dayTemp != -1000 && nightTemp != 1000) {
          //need to  optimize later
          forecastData.add(
            ForecastEntityItem(
              dayOfWeek: days[currentTime.weekday - 1],
              dayTemp: dayTemp.toString(),
              nightTemp: nightTemp.toString(),
              iconCode: iconCode,
            ),
          );
        }

        nightTemp = forecastResponse.list[i + 1].main.tempMin.round();
        dayTemp = forecastResponse.list[i + 1].main.tempMax.round();
      }
    }
    return ForecstEntity(forecast: forecastData);
  }
}

class ForecastEntityItem {
  final String dayOfWeek;
  final String dayTemp;
  final String nightTemp;
  final String iconCode;

  ForecastEntityItem({
    required this.dayOfWeek,
    required this.dayTemp,
    required this.nightTemp,
    required this.iconCode,
  });
}

import 'package:weather/data/network/models/forecast_response_dto.dart';

class WeatherEntity {
  final String locationName;
  final String countryCode;
  final String temperature;
  final String feelsLike;
  final int weatherCode;
  final bool isDay;

  const WeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.locationName,
    required this.countryCode,
    required this.weatherCode,
    required this.isDay,
  });

  factory WeatherEntity.fromForecast(
    CurrentWeatherDto current, {
    required String locationName,
    required String countryCode,
  }) =>
      WeatherEntity(
        temperature: current.temperature.round().toString(),
        feelsLike: current.apparentTemperature.round().toString(),
        locationName: locationName,
        countryCode: countryCode,
        weatherCode: current.weatherCode,
        isDay: current.isDay,
      );
}

class ForecstEntity {
  final List<ForecastEntityItem> forecast;

  const ForecstEntity({required this.forecast});

  factory ForecstEntity.fromForecastResponse(ForecastResponseDto forecastResponse) {
    return ForecstEntity(
      forecast: forecastResponse.daily
          .map(
            (day) => ForecastEntityItem(
              date: day.date,
              dayTemp: day.temperatureMax.round().toString(),
              nightTemp: day.temperatureMin.round().toString(),
              weatherCode: day.weatherCode,
            ),
          )
          .toList(),
    );
  }
}

class ForecastEntityItem {
  final DateTime date;
  final String dayTemp;
  final String nightTemp;
  final int weatherCode;

  ForecastEntityItem({
    required this.date,
    required this.dayTemp,
    required this.nightTemp,
    required this.weatherCode,
  });
}

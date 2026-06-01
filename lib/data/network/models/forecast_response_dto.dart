
class ForecastResponseDto {
  final CurrentWeatherDto current;
  final List<DailyForecastDto> daily;

  const ForecastResponseDto({
    required this.current,
    required this.daily,
  });

  factory ForecastResponseDto.fromJson(final Map<String, dynamic> json) {
    return ForecastResponseDto(
      current: CurrentWeatherDto.fromJson(json['current'] as Map<String, dynamic>),
      daily: DailyForecastDto.listFromJson(json['daily'] as Map<String, dynamic>),
    );
  }
}

class CurrentWeatherDto {
  final num temperature;
  final num apparentTemperature;
  final int weatherCode;
  final bool isDay;

  const CurrentWeatherDto({
    required this.temperature,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.isDay,
  });

  factory CurrentWeatherDto.fromJson(final Map<String, dynamic> json) => CurrentWeatherDto(
        temperature: json['temperature_2m'] as num,
        apparentTemperature: json['apparent_temperature'] as num,
        weatherCode: (json['weather_code'] as num).toInt(),
        isDay: (json['is_day'] as num).toInt() == 1,
      );
}

class DailyForecastDto {
  final DateTime date;
  final int weatherCode;
  final num temperatureMax;
  final num temperatureMin;

  const DailyForecastDto({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
  });

  
  static List<DailyForecastDto> listFromJson(final Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final maxTemps = json['temperature_2m_max'] as List<dynamic>;
    final minTemps = json['temperature_2m_min'] as List<dynamic>;

    return [
      for (int i = 0; i < times.length; i++)
        DailyForecastDto(
          date: DateTime.parse(times[i] as String),
          weatherCode: (codes[i] as num).toInt(),
          temperatureMax: maxTemps[i] as num,
          temperatureMin: minTemps[i] as num,
        ),
    ];
  }
}

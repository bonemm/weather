import 'package:weather/data/network/models/weather_response_dto.dart';

class ForecastResponseDto {
  final List<ItemForecastResponseDto> list;
  final CityResponseDto city;

  factory ForecastResponseDto.fromJson(final Map<String, dynamic> json) {
    return ForecastResponseDto(
      list: (json['list'] as List<dynamic>)
          .map(
            (e) => ItemForecastResponseDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      city: CityResponseDto.fromJson(json['city'] as Map<String, dynamic>),
    );
  }

  const ForecastResponseDto({
    required this.list,
    required this.city,
  });
}

class CityResponseDto {
  final num timezone;

  factory CityResponseDto.fromJson(final Map<String, dynamic> json) {
    return CityResponseDto(timezone: json['timezone'] as num);
  }

  const CityResponseDto({
    required this.timezone,
  });
}

class ItemForecastResponseDto {
  final num dt;
  final MainWeather main;
  final List<Weather> weather;
  final String dtIsoString;

  factory ItemForecastResponseDto.fromJson(final Map<String, dynamic> json) {
    return ItemForecastResponseDto(
      dt: json['dt'] as num,
      main: MainWeather.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      dtIsoString: json['dt_txt'],
    );
  }

  const ItemForecastResponseDto({
    required this.dt,
    required this.main,
    required this.weather,
    required this.dtIsoString,
  });
}

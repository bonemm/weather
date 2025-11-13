import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/models/weather_response_dto.dart';
import 'package:weather/utils/functions.dart';

class SearchHistoryEntry {
  final double longitude;
  final double latitude;
  final String place;
  final String date;
  final int temperature;
  final String iconCode;

  Location get location => Location(latitude: latitude, longitude: longitude, location: '');

  SearchHistoryEntry(
      {required this.longitude,
      required this.latitude,
      required this.place,
      required this.date,
      required this.temperature,
      required this.iconCode});

  factory SearchHistoryEntry.fromWatherResponseDto(WeatherResponseDto weatherResponseDto) {
    return SearchHistoryEntry(
        longitude: weatherResponseDto.coords.longitude,
        latitude: weatherResponseDto.coords.latitude,
        place: weatherResponseDto.name,
        date: formatUnixTime(weatherResponseDto.dt + weatherResponseDto.timezone),
        temperature: weatherResponseDto.weather.temp.round(),
        iconCode: weatherResponseDto.weatherList.first.icon);
  }

  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SearchHistoryEntry(
      longitude: json['longitude'],
      latitude: json['latitude'],
      place: json['location'],
      date: json['date'] ?? '',
      temperature: json['temperature'],
      iconCode: json['icon'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'longitude': longitude,
        'latitude': latitude,
        'location': place,
        'date': date,
        'temperature': temperature,
        'icon': iconCode.toString(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHistoryEntry &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        place == other.place &&
        temperature == other.temperature;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude, place, date, temperature);
}

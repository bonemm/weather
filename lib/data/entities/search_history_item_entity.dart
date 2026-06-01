import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/models/forecast_response_dto.dart';
import 'package:weather/utils/functions.dart';

class SearchHistoryEntry {
  final double longitude;
  final double latitude;
  final String place;
  final String date;
  final int temperature;
  final int weatherCode;
  final bool isDay;

  Location get location => Location(latitude: latitude, longitude: longitude, location: place);

  SearchHistoryEntry({
    required this.longitude,
    required this.latitude,
    required this.place,
    required this.date,
    required this.temperature,
    required this.weatherCode,
    required this.isDay,
  });

  /// Built from a fresh Open-Meteo forecast for [location]; the response has no
  /// place name, so it comes from the location the user picked.
  factory SearchHistoryEntry.fromForecast(CurrentWeatherDto current, Location location) {
    return SearchHistoryEntry(
      longitude: location.longitude,
      latitude: location.latitude,
      place: location.location,
      date: formatDateTime(DateTime.now()),
      temperature: current.temperature.round(),
      weatherCode: current.weatherCode,
      isDay: current.isDay,
    );
  }

  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SearchHistoryEntry(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      place: json['location'] as String,
      date: json['date'] as String? ?? '',
      temperature: (json['temperature'] as num).toInt(),
      weatherCode: (json['weather_code'] as num).toInt(),
      isDay: json['is_day'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'longitude': longitude,
        'latitude': latitude,
        'location': place,
        'date': date,
        'temperature': temperature,
        'weather_code': weatherCode,
        'is_day': isDay,
      };

  // Identity is the saved location (lat/lon/place); temperature and date are
  // just the latest snapshot, so they are intentionally excluded. This lets a
  // refreshed entry still match its previous version for dedupe/removal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHistoryEntry &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        place == other.place;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude, place);
}

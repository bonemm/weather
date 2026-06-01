import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather/data/network/models/forecast_response_dto.dart';
import 'package:weather/data/network/models/geocoding_response_dto.dart';
import 'package:weather/data/network/models/reverse_geocoding_dto.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/api/dio_builder.dart';

/// Client for the Open-Meteo APIs (https://open-meteo.com/en/docs).
///
/// Open-Meteo is keyless and free. Forecast and geocoding live on different
/// hosts, so each request uses an absolute URL.
class ApiService {
  static const _forecastUrl = 'https://api.open-meteo.com/v1/forecast';
  static const _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  // Open-Meteo geocoding is forward-only, so reverse lookups (coords -> place
  // name) use BigDataCloud's free, keyless endpoint.
  static const _reverseGeocodingUrl = 'https://api.bigdatacloud.net/data/reverse-geocode-client';

  static const _forecastDays = 10;

  final String _temperatureUnit = 'celsius';
  late final Dio _dio;

  ApiService() {
    _dio = DioBuilder().dio;
  }

  Future<ForecastResponseDto?> getForecast(Location location) async {
    try {
      final response = await _dio.get(
        _forecastUrl,
        queryParameters: {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'current': 'temperature_2m,apparent_temperature,weather_code,is_day',
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          'temperature_unit': _temperatureUnit,
          'timezone': 'auto',
          'forecast_days': _forecastDays,
        },
      );

      if (response.statusCode == 200) {
        log(jsonEncode(response.data), name: 'ApiService.getForecast');
        return ForecastResponseDto.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e, st) {
      log('getForecast failed', name: 'ApiService', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<GeocodingLocationDto>?> getLocationsByPlaceName(String placeName, {String language = 'en'}) async {
    try {
      final response = await _dio.get(
        _geocodingUrl,
        queryParameters: {
          'name': placeName,
          'count': 5,
          'language': language,
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List<dynamic>?;
        if (results == null) return [];
        return results.map((e) => GeocodingLocationDto.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        return null;
      }
    } catch (e, st) {
      log('getLocationsByPlaceName failed for "$placeName"', name: 'ApiService', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<ReverseGeocodingDto?> reverseGeocode(double latitude, double longitude, {String language = 'en'}) async {
    try {
      final response = await _dio.get(
        _reverseGeocodingUrl,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'localityLanguage': language,
        },
      );

      if (response.statusCode == 200) {
        return ReverseGeocodingDto.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e, st) {
      log('reverseGeocode failed for ($latitude, $longitude)', name: 'ApiService', error: e, stackTrace: st);
      rethrow;
    }
  }
}

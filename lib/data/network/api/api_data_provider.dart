import 'package:dio/dio.dart';
import 'package:weather/data/network/models/forecast_response_dto.dart';
import 'package:weather/data/network/models/geocoding_response_dto.dart';
import 'package:weather/data/network/models/weather_response_dto.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/api/dio_builder.dart';
import 'package:weather/data/network/api/interceptors.dart';

class ApiService {
  static const _apiKey = "b4a82d8c1777a9686ee7cb26ce7e3b0f"; //String.fromEnvironment('WEATHER_API_KEY');

  final String _mode = 'json';
  late final String _language;
  late final String _units;
  late final Dio _dio;

  ApiService() {
    _language = 'ru';
    _units = 'metric';
    _dio = _getDioClient(_apiKey);
  }

  Dio _getDioClient(String apiKey) {
    if (apiKey.isEmpty) {
      throw Exception('API_KEY is not set. Use --dart-define=WEATHER_API_KEY=your_key');
    }
    var builder = DioBuilder();
    var apiKeyInterceptor = ApiTokenInterceptor(apiKey);
    builder.addIntercepror(apiKeyInterceptor);

    return builder.dio;
  }

  Future<WeatherResponseDto?> getWeather(Location location) async {
    final response = await _dio.get(
      '/data/2.5/weather',
      queryParameters: {
        'lat': location.latitude,
        'lon': location.longitude,
        'mode': _mode,
        'lang': _language,
        'units': _units,
      },
    );

    if (response.statusCode == 200) {
      return WeatherResponseDto.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<ForecastResponseDto?> getForecast(Location location) async {
    final response = await _dio.get(
      '/data/2.5/forecast',
      queryParameters: {
        'lat': location.latitude,
        'lon': location.longitude,
        'mode': _mode,
        'lang': _language,
        'units': _units,
        'cnt': 40,
      },
    );

    if (response.statusCode == 200) {
      return ForecastResponseDto.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<List<GeocodingLocationDto>?> getLocationsByPlaceName(String placeName) async {
    final response = await _dio.get(
      '/geo/1.0/direct',
      queryParameters: {
        'q': placeName,
        'appid': _apiKey,
        'limit': 5,
      },
    );
    final responseList = response.data as Iterable;

    if (response.statusCode == 200) {
      return responseList.map((e) => GeocodingLocationDto.fromJson(e)).toList();
    } else {
      return null;
    }
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/api/api_data_provider.dart';

abstract interface class IWeatherRepository {
  Future<Position> getCurrentLocation();

  Future<WeatherEntity> fetchData(Location location);

  Future<ForecstEntity> fetchForecast(Location location);
}

class WeatherRepository implements IWeatherRepository {
  final _apiDataProvider = ApiService();

  @override
  Future<WeatherEntity> fetchData(Location location) async {
    var weatherResp = await _apiDataProvider.getWeather(location);
    if (weatherResp == null) {
      throw Exception('Weather data is NULL');
    }
    return WeatherEntity.fromWeatherDto(weatherResp);
  }

  @override
  Future<ForecstEntity> fetchForecast(Location location) async {
    var forecastData = await _apiDataProvider.getForecast(location);

    if (forecastData == null) {
      throw Exception('Forecast data is NULL');
    }

    return ForecstEntity.fromForecastResponse(forecastData);
  }

  @override
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      timeLimit: Duration(seconds: 30),
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return position;
  }
}

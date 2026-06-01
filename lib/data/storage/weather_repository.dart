import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/api/api_data_provider.dart';
import 'package:weather/ui/locale/locale_service.dart';


typedef WeatherBundle = ({WeatherEntity weather, ForecstEntity forecast});

abstract interface class IWeatherRepository {
  Future<Location> currentLocation();

  Future<WeatherBundle> fetchWeather(Location location);
}

class WeatherRepository implements IWeatherRepository {
  final ApiService _apiDataProvider;
  final LocaleService _localeService;

  WeatherRepository({required ApiService apiService, required LocaleService localeService})
      : _apiDataProvider = apiService,
        _localeService = localeService;

 
  @override
  Future<Location> currentLocation() async {
    final position = await _getCurrentPosition();
    final base = Location.fromPosition(position: position);

    try {
      final place = await _apiDataProvider.reverseGeocode(
        position.latitude,
        position.longitude,
        language: _localeService.languageCode,
      );
     
      if (place != null && place.city.isNotEmpty && place.countryCode.isNotEmpty) {
        return base.copyWith(location: '${place.city}, ${place.countryCode}');
      }
    } catch (e, st) {
      // Reverse geocoding is best-effort; log and fall through to an empty label.
      log('reverseGeocode failed, using empty place label', name: 'WeatherRepository', error: e, stackTrace: st);
    }
    return base.copyWith(location: '');
  }

  @override
  Future<WeatherBundle> fetchWeather(Location location) async {
    final forecastResp = await _apiDataProvider.getForecast(location);
    if (forecastResp == null) {
      throw Exception('Weather data is NULL');
    }

    final names = _splitLocationLabel(location.location);
    final weather = WeatherEntity.fromForecast(
      forecastResp.current,
      locationName: names.name,
      countryCode: names.country,
    );
    final forecast = ForecstEntity.fromForecastResponse(forecastResp);
    return (weather: weather, forecast: forecast);
  }

  ({String name, String country}) _splitLocationLabel(String label) {
    final parts = label.split(',').map((p) => p.trim()).toList();
    if (parts.length >= 2) {
      return (name: parts[0], country: parts[1]);
    }
    return (name: label, country: '');
  }

  Future<Position> _getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them in your device settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission permanently denied. Please enable it in your device settings.',
        );
      }

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 30),
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      return position;
    } catch (e, st) {
      log('getCurrentPosition failed', name: 'WeatherRepository', error: e, stackTrace: st);
      rethrow;
    }
  }
}

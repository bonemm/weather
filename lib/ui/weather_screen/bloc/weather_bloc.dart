import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/storage/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final IWeatherRepository _weatherRepository;

  /// The place currently shown. `null` means the current geolocation; a value
  /// means a user-selected location. Used so pull-to-refresh reloads the same
  /// place rather than always reverting to geolocation.
  Location? _selectedLocation;

  WeatherBloc({required IWeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherInitState()) {
    on<WeatherEvent>(
      (event, emit) => switch (event) {
        FetchWeatherFromCurrentLocation() => _fetchWeatherData(emit),
        FetchWeatherDataFromSelectedLocation() => _fetchWeatherSelectedLocation(event, emit),
        RefreshWeather() => _refreshWeather(emit),
        _ => _defaultMethod(),
      },
    );
  }

  Future<void> _fetchWeatherData(Emitter<WeatherState> emit, {bool showLoading = true}) async {
    _selectedLocation = null;
    if (showLoading) emit(WeatherLoadingState());
    try {
      var location = await _weatherRepository.currentLocation();
      var bundle = await _weatherRepository.fetchWeather(location);
      emit(WeatherSuccessLoadedState(bundle.weather, bundle.forecast));
    } catch (e, st) {
      log('Failed to load weather for current location', name: 'WeatherBloc', error: e, stackTrace: st);
      emit(WeatherErrorState(errorMessage: '$e'));
    }
  }

  Future<void> _fetchWeatherSelectedLocation(
      FetchWeatherDataFromSelectedLocation event, Emitter<WeatherState> emit,
      {bool showLoading = true}) async {
    _selectedLocation = event.location;
    if (showLoading) emit(WeatherLoadingState());
    try {
      var bundle = await _weatherRepository.fetchWeather(event.location);
      emit(WeatherSuccessLoadedState(bundle.weather, bundle.forecast));
    } catch (e, st) {
      log('Failed to load weather for selected location', name: 'WeatherBloc', error: e, stackTrace: st);
      emit(WeatherErrorState(errorMessage: '$e'));
    }
  }

  /// Reloads the active place without a loading screen (the RefreshIndicator
  /// shows its own spinner).
  Future<void> _refreshWeather(Emitter<WeatherState> emit) {
    final location = _selectedLocation;
    if (location != null) {
      return _fetchWeatherSelectedLocation(
        FetchWeatherDataFromSelectedLocation(location),
        emit,
        showLoading: false,
      );
    }
    return _fetchWeatherData(emit, showLoading: false);
  }

  void _defaultMethod() {}
}

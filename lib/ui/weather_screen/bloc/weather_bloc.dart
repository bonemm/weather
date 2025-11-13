import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/storage/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final IWeatherRepository _weatherRepository;

  WeatherBloc({required IWeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherInitState()) {
    on<WeatherEvent>(
      (event, emit) => switch (event) {
        FetchWeatherFromCurrentLocation() => _fetchWeatherData(emit),
        FetchWeatherDataFromSelectedLocation() => _fetchWeatherSelectedLocation(event, emit),
        _ => _defaultMethod(),
      },
    );
  }

  Future<void> _fetchWeatherData(Emitter<WeatherState> emit) async {
    emit(WeatherLoadingState());
    try {
      var position = await _weatherRepository.getCurrentLocation();
      var location = Location.fromPosition(position: position);

      var weatherData = await _weatherRepository.fetchData(location);
      var forecastData = await _weatherRepository.fetchForecast(location);
      emit(WeatherSuccessLoadedState(weatherData, forecastData));
    } catch (e, st) {
      emit(WeatherErrorState(errorMessage: 'No data: $e $st'));
    }
  }

  Future<void> _fetchWeatherSelectedLocation(
      FetchWeatherDataFromSelectedLocation event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadingState());
    try {
      var weatherData = await _weatherRepository.fetchData(event.location);
      var forecastData = await _weatherRepository.fetchForecast(event.location);
      emit(WeatherSuccessLoadedState(weatherData, forecastData));
    } catch (e, st) {
      emit(WeatherErrorState(errorMessage: 'ERROR FETCH WEAHER FROM LOCATION \n: $e $st'));
    }
  }

  void _defaultMethod() {}
}

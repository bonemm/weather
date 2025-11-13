part of 'weather_bloc.dart';

sealed class WeatherState {
  const WeatherState();
}

class WeatherInitState extends WeatherState {
  const WeatherInitState();
}

class WeatherLoadingState extends WeatherState {
  const WeatherLoadingState();
}

class WeatherSuccessLoadedState extends WeatherState {
  final WeatherEntity weatherData;
  final ForecstEntity forecast;

  const WeatherSuccessLoadedState(this.weatherData, this.forecast);
}

class WeatherErrorState extends WeatherState {
  final String errorMessage;

  WeatherErrorState({required this.errorMessage});
}

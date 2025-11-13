part of 'weather_bloc.dart';

sealed class WeatherEvent {
  const WeatherEvent();
}

class FetchWeatherDataFromSelectedLocation extends WeatherEvent {
  final Location location;

  const FetchWeatherDataFromSelectedLocation(this.location);
}

class FetchWeatherFromCurrentLocation extends WeatherEvent {
  final Location location;

  const FetchWeatherFromCurrentLocation(this.location);
}

class WeatherDataLoaded extends WeatherEvent {
  const WeatherDataLoaded();
}

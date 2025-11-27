part of 'weather_bloc.dart';

sealed class WeatherEvent {
  const WeatherEvent();
}

class FetchWeatherDataFromSelectedLocation extends WeatherEvent {
  final Location location;

  const FetchWeatherDataFromSelectedLocation(this.location);
}

class FetchWeatherFromCurrentLocation extends WeatherEvent {
  const FetchWeatherFromCurrentLocation();
}

class WeatherDataLoaded extends WeatherEvent {
  const WeatherDataLoaded();
}

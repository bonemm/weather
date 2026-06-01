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

/// Pull-to-refresh: re-fetches whatever place is currently shown (the last
/// selected location, or the current geolocation) without a loading screen.
class RefreshWeather extends WeatherEvent {
  const RefreshWeather();
}

class WeatherDataLoaded extends WeatherEvent {
  const WeatherDataLoaded();
}

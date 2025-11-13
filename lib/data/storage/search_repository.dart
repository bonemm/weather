import 'dart:async';
import 'dart:convert';
import 'package:weather/data/entities/search_history_item_entity.dart';
import 'package:weather/data/entities/weather_search_history.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/data/network/api/api_data_provider.dart';
import 'package:weather/data/storage/stored_data_provider.dart';

class SearchRepository {
  final ApiService _apiDataProvider = ApiService();
  final StoredDataProvider _spDataProvider = StoredDataProvider(); //refactor to correct di

  Future<List<Location>> getLocationsByNamePart(String namePart) async {
    final locations = await _apiDataProvider.getLocationsByPlaceName(namePart);

    if (locations == null) {
      return [];
    } else {
      return locations.map((e) => Location.fromGeocodingResponse(e)).toList();
    }
  }

  Future<void> saveNewLocation(Location location) async {
    var newLocationWeather = await _apiDataProvider.getWeather(location);
    if (newLocationWeather != null) {
      var history = await getHistory();
      var searchHistoryRecord = SearchHistoryEntry.fromWatherResponseDto(newLocationWeather);
      if (!history.entries.contains(searchHistoryRecord)) {
        var updatedHistory = history.addEntry(searchHistoryRecord);
        saveRawData(jsonEncode(updatedHistory.toJson()));
      }
    }
  }

  Future<void> removeLocation(SearchHistoryEntry historyItem) async {
    var history = await getHistory();
    var updatedHistory = history.removeEntry(historyItem);
    saveRawData(jsonEncode(updatedHistory.toJson()));
  }

  FutureOr<WeatherSearchHistory> getHistory() async {
    var rawString = await getRawData();
    if (rawString == null) return WeatherSearchHistory.initial();

    var json = jsonDecode(rawString) as Map<String, dynamic>;
    var weatherData = WeatherSearchHistory.fromJson(json);
    return weatherData;
  }

  Future<WeatherSearchHistory> updateWeatherHistoryData() async {
    var storedHistory = await getHistory();
    var updatedWeatherData = <SearchHistoryEntry>[];

    for (var e in storedHistory.entries) {
      var weather = await _apiDataProvider.getWeather(e.location);
      if (weather != null) {
        updatedWeatherData.add(SearchHistoryEntry.fromWatherResponseDto(weather));
      }
    }
    var updatedHistory = WeatherSearchHistory(entries: updatedWeatherData, timestamp: DateTime.now());
    saveRawData(jsonEncode(updatedHistory.toJson()));
    return updatedHistory;
  }

  Future<String?> getRawData() => _spDataProvider.getFavoriteList();

  Future<bool> saveRawData(String? item) => _spDataProvider.setFavoriteList(item);
}

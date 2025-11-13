import 'package:weather/data/entities/search_history_item_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';

sealed class SearchPlaceState {
  const SearchPlaceState();
}

class SearchPlaceInitialState extends SearchPlaceState {
  const SearchPlaceInitialState();
}

class SearchPlacesScreenLoadedState extends SearchPlaceState {
  final List<SearchHistoryEntry> history;
  const SearchPlacesScreenLoadedState({required this.history});
}

class SearchPlaceLoadedPlacesState extends SearchPlaceState {
  final List<Location> lacations;

  const SearchPlaceLoadedPlacesState({required this.lacations});
}

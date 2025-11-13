import 'package:weather/data/entities/search_history_item_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';

sealed class SearchPlaceEvent {
  const SearchPlaceEvent();
}

class SearchPlaceScreenLoaded extends SearchPlaceEvent {
  const SearchPlaceScreenLoaded();
}

class SearchPlaceSearchRequested extends SearchPlaceEvent {
  final String query;

  const SearchPlaceSearchRequested({required this.query});
}

class SearchPlaceScreenClosed extends SearchPlaceEvent {
  const SearchPlaceScreenClosed();
}

class SearchPlaceNameTextEdited extends SearchPlaceEvent {
  final String text;

  const SearchPlaceNameTextEdited(this.text);
}

class SearchPlaceNewLocationSelected extends SearchPlaceEvent {
  final Location location;

  const SearchPlaceNewLocationSelected(this.location);
}

class SearchPlaceRemoveLocation extends SearchPlaceEvent {
  final SearchHistoryEntry historyItem;

  const SearchPlaceRemoveLocation(this.historyItem);
}

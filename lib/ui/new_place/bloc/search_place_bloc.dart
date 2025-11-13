import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/entities/weather_search_history.dart';
import 'package:weather/data/storage/search_repository.dart';
import 'package:weather/ui/new_place/bloc/search_place_event.dart';
import 'package:weather/ui/new_place/bloc/search_place_state.dart';

class SearchPlaceBloc extends Bloc<SearchPlaceEvent, SearchPlaceState> {
  final SearchRepository _searchRepository;
  Timer? _searchDebounceTimer;

  SearchPlaceBloc({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(SearchPlaceInitialState()) {
    on<SearchPlaceEvent>(
      (event, emit) => switch (event) {
        SearchPlaceNameTextEdited() => _onDebaunsedSearchRequest(event),
        SearchPlaceSearchRequested() => _performSearch(event, emit),
        SearchPlaceScreenClosed() => _onSearchScreenLoaded(event, emit),
        SearchPlaceNewLocationSelected() => _onNewLocationSelected(event, emit),
        SearchPlaceScreenLoaded() => _onSearchPlaceScreenLoaded(event, emit),
        SearchPlaceRemoveLocation() => _onRemoveHistoryItem(event, emit)
      },
    );
  }

  Future<void> _onSearchScreenLoaded(SearchPlaceScreenClosed event, Emitter<SearchPlaceState> emit) async {
    try {
      emit(SearchPlaceInitialState());
    } catch (e, st) {
      log('$e \n $st');
    }
  }

  Future<void> _performSearch(SearchPlaceSearchRequested event, Emitter<SearchPlaceState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchPlaceLoadedPlacesState(lacations: []));
      return;
    }

    try {
      var locations = await _searchRepository.getLocationsByNamePart(event.query);
      emit(SearchPlaceLoadedPlacesState(lacations: locations));
    } catch (e, st) {
      log('$e \n $st');
    }
  }

  Future<void> _onDebaunsedSearchRequest(SearchPlaceNameTextEdited event) async {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      add(SearchPlaceSearchRequested(query: event.text));
    });
  }

  Future<void> _onNewLocationSelected(SearchPlaceNewLocationSelected event, Emitter<SearchPlaceState> emit) async {
    try {
      await _searchRepository.saveNewLocation(event.location);
      _updateHistoryState();
    } catch (e, st) {
      log('$e \n $st');
    }
  }

  Future<void> _onSearchPlaceScreenLoaded(SearchPlaceScreenLoaded event, Emitter<SearchPlaceState> emit) async {
    try {
      var history = await _searchRepository.getHistory();
      emit(SearchPlacesScreenLoadedState(history: history.entries));
      if (_isDataOutdated(history)) {
        history = await _searchRepository.updateWeatherHistoryData();
        emit(SearchPlacesScreenLoadedState(history: history.entries));
      }
    } catch (e, st) {
      log('$e \n $st');
    }
  }

  void _updateHistoryState() {
    add(SearchPlaceScreenLoaded());
  }

  bool _isDataOutdated(WeatherSearchHistory history) {
    return DateTime.now().difference(history.timestamp).inHours >= 3;
  }

  Future<void> _onRemoveHistoryItem(SearchPlaceRemoveLocation event, Emitter<SearchPlaceState> emit) async {
    try {
      await _searchRepository.removeLocation(event.historyItem);
      _updateHistoryState();
    } catch (e, st) {
      log('$e \n $st');
    }
  }
}

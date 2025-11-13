import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/entities/search_history_item_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/di/dependencies_scope.dart';
import 'package:weather/ui/new_place/bloc/search_place_bloc.dart';
import 'package:weather/ui/new_place/bloc/search_place_event.dart';
import 'package:weather/ui/new_place/bloc/search_place_state.dart';
import 'package:weather/utils/weather_icon_mapper.dart';

class NewPlacesScreen extends StatelessWidget {
  const NewPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: DependenciesScope.of(context).searchPlaceBloc,
      child: _SearchPlacesWidget(),
    );
  }
}

class _SearchPlacesWidget extends StatefulWidget {
  const _SearchPlacesWidget();

  @override
  State<_SearchPlacesWidget> createState() => _SearchPlacesWidgetState();
}

class _SearchPlacesWidgetState extends State<_SearchPlacesWidget> {
  final TextEditingController _tec = TextEditingController();
  final _tfn = FocusNode();
  Location? selectedLocation;

  void onListItemSelected(Location selectedCity) {
    selectedLocation = selectedCity;
    context.read<SearchPlaceBloc>().add(SearchPlaceScreenClosed());
    _tec.text = selectedCity.location;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onNewLocationSelected() {
    if (selectedLocation != null) {
      context.read<SearchPlaceBloc>().add(SearchPlaceNewLocationSelected(selectedLocation!));
    }
    Navigator.pop(context, selectedLocation);
  }

  @override
  void initState() {
    context.read<SearchPlaceBloc>().add(SearchPlaceScreenLoaded());
    super.initState();
  }

  @override
  void dispose() {
    _tec.dispose();
    _tfn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<SearchPlaceBloc>().add(SearchPlaceScreenClosed());
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Locations'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SearchTextField(tfn: _tfn, tec: _tec),
            Stack(children: [
              BlocBuilder<SearchPlaceBloc, SearchPlaceState>(
                buildWhen: (previous, current) =>
                    current is SearchPlacesScreenLoadedState && current.history.isNotEmpty,
                builder: (context, state) {
                  return switch (state) {
                    SearchPlacesScreenLoadedState() => _SearchHistoryLocations(history: state.history),
                    _ => SizedBox.shrink(),
                  };
                },
              ),
              BlocBuilder<SearchPlaceBloc, SearchPlaceState>(
                builder: (context, state) {
                  return switch (state) {
                    SearchPlaceLoadedPlacesState() => SuggestionsList(
                        locations: state.lacations,
                        onLocationSelected: onListItemSelected,
                      ),
                    _ => SizedBox.shrink(),
                  };
                },
              ),
            ]),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: FloatingActionButton.extended(
                onPressed: () => _onNewLocationSelected(),
                icon: Icon(
                  Icons.where_to_vote_rounded,
                  size: 30,
                  color: Color(0xFF00908A),
                ),
                label: Text(
                  'Select location',
                  style: TextStyle(color: Color(0xFF00978D), fontSize: 16),
                ),
                elevation: 1,
                backgroundColor: Color(0xFFA5C8D1)),
          ),
        ),
      ),
    );
  }
}

class _SearchHistoryLocations extends StatelessWidget {
  const _SearchHistoryLocations({required this.history});

  final List<SearchHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: history.length,
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return _HistoryLocationItem(historyItem: history[index]);
          },
        ),
      ],
    );
  }
}

class _HistoryLocationItem extends StatelessWidget {
  const _HistoryLocationItem({required this.historyItem});

  final SearchHistoryEntry historyItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: ValueKey<String>(historyItem.place),
        background: const _DismissibleBackground(isLeft: true),
        secondaryBackground: const _DismissibleBackground(isLeft: false),
        onDismissed: (_) => context.read<SearchPlaceBloc>().add(SearchPlaceRemoveLocation(historyItem)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 70),
          child: ColoredBox(
            color: Color(0xFFA5C8D1),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          historyItem.place,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 2),
                        Text(
                          historyItem.date,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    getIconData(historyItem.iconCode),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${historyItem.temperature}°',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground({required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade300,
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
    );
  }
}

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({super.key, required this.locations, required this.onLocationSelected});
  final List<Location> locations;
  final Function(Location) onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color(0xFFA5C8D1),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => ListTile(
          onTap: () => onLocationSelected(locations[index]),
          leading: Icon(Icons.place_outlined),
          title: Text(locations[index].location),
        ),
        itemCount: locations.length,
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required FocusNode tfn, required TextEditingController tec})
      : _tfn = tfn,
        _tec = tec;

  final FocusNode _tfn;
  final TextEditingController _tec;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _tec,
        focusNode: _tfn,
        onChanged: (text) => context.read<SearchPlaceBloc>().add(SearchPlaceNameTextEdited(text)),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black45),
          hintText: 'search a city...',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey, width: 2),
          ),
        ),
      ),
    );
  }
}

import 'package:weather/data/storage/search_repository.dart';
import 'package:weather/data/storage/weather_repository.dart';
import 'package:weather/ui/new_place/bloc/search_place_bloc.dart';
import 'package:weather/ui/weather_screen/bloc/weather_bloc.dart';

class DIContainer {
  late final WeatherRepository weatherRepository;
  late final SearchRepository searchRepository;
  late final WeatherBloc weatherBloc;
  late final SearchPlaceBloc searchPlaceBloc;

  DIContainer() {
    weatherRepository = WeatherRepository();
    searchRepository = SearchRepository();
    weatherBloc = WeatherBloc(weatherRepository: weatherRepository);
    searchPlaceBloc = SearchPlaceBloc(searchRepository: searchRepository);
  }
}

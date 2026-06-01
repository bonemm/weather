import 'package:weather/data/network/api/api_data_provider.dart';
import 'package:weather/data/storage/search_repository.dart';
import 'package:weather/data/storage/weather_repository.dart';
import 'package:weather/ui/locale/locale_service.dart';
import 'package:weather/ui/new_place/bloc/search_place_bloc.dart';
import 'package:weather/ui/settings/settings_repoitory.dart';
import 'package:weather/ui/theme/theme_service.dart';
import 'package:weather/ui/weather_screen/bloc/weather_bloc.dart';

class DIContainer {
  late final ApiService apiService;
  late final WeatherRepository weatherRepository;
  late final SearchRepository searchRepository;
  late final WeatherBloc weatherBloc;
  late final SearchPlaceBloc searchPlaceBloc;
  late final ThemeService themeService;
  late final LocaleService localeService;

  DIContainer() {
    final settingsRepository = SettingsRepoitory();
    localeService = LocaleService(settingsRepository);
    apiService = ApiService();
    weatherRepository = WeatherRepository(apiService: apiService, localeService: localeService);
    searchRepository = SearchRepository(apiService: apiService, localeService: localeService);
    weatherBloc = WeatherBloc(weatherRepository: weatherRepository);
    searchPlaceBloc = SearchPlaceBloc(searchRepository: searchRepository);
    themeService = ThemeService(settingsRepository);
  }
}

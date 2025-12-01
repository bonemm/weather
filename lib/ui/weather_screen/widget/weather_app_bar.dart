import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/ui/new_place/search_place_screen.dart';
import 'package:weather/ui/settings/settings_screen.dart';
import 'package:weather/ui/weather_screen/bloc/weather_bloc.dart';

class WeatherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherAppBar({super.key});

  void _addNewLocationMenu(BuildContext context) async {
    final locationResult = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NewPlacesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); // Start from left
          const end = Offset.zero; // End at center
          const curve = Curves.easeIn; // Animation curve

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );

    if (locationResult != null && context.mounted) {
      context.read<WeatherBloc>().add(FetchWeatherDataFromSelectedLocation(locationResult));
    }
  }

  void _toSettingsScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => _addNewLocationMenu(context),
        icon: Icon(Icons.menu),
      ),
      title: Text('Weather'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _toSettingsScreen(context),
          icon: Icon(Icons.settings),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60);
}

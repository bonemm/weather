import 'package:flutter/material.dart';
import 'package:weather/di/dependencies_scope.dart';
import 'package:weather/di/di_container.dart';
import 'package:weather/ui/weather_screen/weather_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final DIContainer dependencies = DIContainer();

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: dependencies,
      child: Builder(builder: (context) {
        var themeService = DependenciesScope.of(context).themeService;
        return AnimatedBuilder(
            animation: themeService,
            builder: (context, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: WeatherScreen(),
                theme: themeService.themeData,
              );
            });
      }),
    );
  }
}

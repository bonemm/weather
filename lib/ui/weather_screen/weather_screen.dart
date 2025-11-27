import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/data/geolocation/models/location.dart';
import 'package:weather/di/dependencies_scope.dart';
import 'package:weather/ui/weather_screen/bloc/weather_bloc.dart';
import 'package:weather/ui/weather_screen/widget/forecast_list.dart';
import 'package:weather/ui/weather_screen/widget/place_name.dart';
import 'package:weather/ui/weather_screen/widget/tempareture.dart';
import 'package:weather/ui/weather_screen/widget/weather_app_bar.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: DependenciesScope.of(context).weatherBloc,
      child: _WeatherWidget(),
    );
  }
}

class _WeatherWidget extends StatefulWidget {
  const _WeatherWidget();

  @override
  State<_WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<_WeatherWidget> {
  @override
  void initState() {
    super.initState();
    // context.read<WeatherBloc>().add(FetchWeatherFromCurrentLocation());
    context.read<WeatherBloc>().add(FetchWeatherDataFromSelectedLocation(Location.initial()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WeatherAppBar(),
      body: Column(
        spacing: 16,
        children: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return switch (state) {
                WeatherLoadingState() => LoadingWidget(),
                WeatherSuccessLoadedState() => WeatherInfo(
                    name: state.weatherData.locationName,
                    countryCode: state.weatherData.countryCode,
                    temp: state.weatherData.temperature,
                    feelsLike: state.weatherData.feelsLike,
                    forecast: state.forecast.forecast,
                  ),
                _ => Center(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Icon(
                        Icons.sunny,
                        size: 50,
                      ),
                    ),
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  const WeatherInfo({
    super.key,
    required this.name,
    required this.countryCode,
    required this.temp,
    required this.feelsLike,
    required this.forecast,
  });

  final String name;
  final String countryCode;
  final String temp;
  final String feelsLike;
  final List<ForecastEntityItem> forecast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Expanded(
          child: Column(
            children: [
              PlaceName(name: name, countryCode: countryCode),
              SizedBox(height: 16),
              TemperatureSpace(
                temp: temp,
                feelsLike: feelsLike,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Four-day forecast',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              ForecastList(
                forecast: forecast,
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16,
        children: [
          SizedBox(height: 30),
          SizedBox(
            height: 300,
            width: 300,
            child: ColoredBox(
              color: Colors.blueGrey.shade100,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OffsetDiagonalLinePainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;
  final double xOffsetFraction;

  OffsetDiagonalLinePainter({
    this.lineColor = Colors.black,
    this.strokeWidth = 2.0,
    this.xOffsetFraction = 1 / 2, // Start at 1/3 of width by default
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Calculate starting point (x = width/3, y = corresponding position for 45° angle)
    final startX = size.width * xOffsetFraction - 30;
    final startY = size.height - 50; // Start from bottom

    // Calculate ending point (maintain 45° angle)
    // For 45° angle, the rise equals the run, so we move equally in x and y directions
    final availableRun = size.width - startX; // Remaining horizontal space
    final availableRise = size.height; // Vertical space from bottom to top

    // Use the smaller of the two to maintain 45° angle without going out of bounds
    final distance = availableRun < availableRise ? availableRun : availableRise;

    final endX = startX + distance - 50;
    final endY = startY - distance + 50; // Moving upward

    canvas.drawLine(
      Offset(startX, startY), // Start from (width/3, bottom)
      Offset(endX, endY), // End at calculated point
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagonalLinePainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;

  DiagonalLinePainter({this.lineColor = Colors.black, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    canvas.drawLine(
      Offset(size.width / 3, 250),
      Offset(size.width - 100, (size.width / 5)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

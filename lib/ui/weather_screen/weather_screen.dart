import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/entities/weather_entity.dart';
import 'package:weather/di/dependencies_scope.dart';
import 'package:weather/l10n/app_localizations.dart';
import 'package:weather/ui/weather_screen/bloc/weather_bloc.dart';
import 'package:weather/ui/weather_screen/widget/forecast_list.dart';
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
    context.read<WeatherBloc>().add(FetchWeatherFromCurrentLocation());
    //context.read<WeatherBloc>().add(FetchWeatherDataFromSelectedLocation(Location.initial()));
  }

  Future<void> _onRefresh() {
    final bloc = context.read<WeatherBloc>();
    bloc.add(const RefreshWeather());
    // Keep the indicator spinning until the refresh settles into a terminal state.
    return bloc.stream.firstWhere((s) => s is WeatherSuccessLoadedState || s is WeatherErrorState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WeatherAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            return switch (state) {
              WeatherSuccessLoadedState() => WeatherInfo(
                  temp: state.weatherData.temperature,
                  feelsLike: state.weatherData.feelsLike,
                  forecast: state.forecast.forecast,
                  weatherCode: state.weatherData.weatherCode,
                  isDay: state.weatherData.isDay,
                ),
              // Loading / error / initial: keep a simple scrollable filler so
              // pull-to-refresh still works.
              _ => _ScrollableFiller(
                  child: state is WeatherLoadingState ? const LoadingWidget() : const _FallbackContent(),
                ),
            };
          },
        ),
      ),
    );
  }
}

/// Makes a short child fill the viewport and stay scrollable, so the
/// pull-to-refresh gesture works on the loading/error screens.
class _ScrollableFiller extends StatelessWidget {
  const _ScrollableFiller({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}

class _FallbackContent extends StatelessWidget {
  const _FallbackContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Icon(Icons.sunny, size: 50),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  const WeatherInfo(
      {super.key,
      required this.temp,
      required this.feelsLike,
      required this.forecast,
      required this.weatherCode,
      required this.isDay});

  final int weatherCode;
  final bool isDay;
  final String temp;
  final String feelsLike;
  final List<ForecastEntityItem> forecast;

  // Expanded/collapsed heights for the collapsing current-weather header.
  static const double _expandedHeight = 320;
  static const double _collapsedHeight = 132;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          expandedHeight: _expandedHeight,
          collapsedHeight: _collapsedHeight,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              // Collapse progress from the current header height: 0 expanded -> 1 collapsed.
              final maxH = _expandedHeight + MediaQuery.of(context).padding.top;
              final minH = _collapsedHeight + MediaQuery.of(context).padding.top;
              final t = ((maxH - constraints.maxHeight) / (maxH - minH)).clamp(0.0, 1.0);
              return FlexibleSpaceBar(
                background: SafeArea(
                  bottom: false,
                  child: Center(
                    child: TemperatureSpace(
                      temp: temp,
                      feelsLike: feelsLike,
                      weatherCode: weatherCode,
                      isDay: isDay,
                      t: t,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppLocalizations.of(context).tenDayForecast,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ForecastList(forecast: forecast),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
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

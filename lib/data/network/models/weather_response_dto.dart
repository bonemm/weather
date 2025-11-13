class WeatherResponseDto {
  final Coords coords;
  final List<Weather> weatherList;
  final MainWeather weather;
  final num visibility;
  final Wind wind;
  final Rain? rain;
  final Snow? snow;
  final Clouds clouds;
  final Sys sys;
  final int dt;
  final int timezone;
  final String name;

  WeatherResponseDto({
    required this.coords,
    required this.weatherList,
    required this.weather,
    required this.visibility,
    required this.wind,
    required this.rain,
    required this.snow,
    required this.clouds,
    required this.sys,
    required this.dt,
    required this.timezone,
    required this.name,
  });

  factory WeatherResponseDto.fromJson(Map<String, dynamic> json) {
    return WeatherResponseDto(
      coords: Coords.fromJson(json['coord'] as Map<String, dynamic>),
      weatherList: (json['weather'] as List<dynamic>).map((e) => Weather.fromJson(e as Map<String, dynamic>)).toList(),
      weather: MainWeather.fromJson(json['main'] as Map<String, dynamic>),
      visibility: json['visibility'] as num,
      wind: Wind.fromJson(json['wind'] as Map<String, dynamic>),
      rain: json['rain'] == null ? null : Rain.fromJson(json['rain'] as Map<String, dynamic>),
      snow: json['snow'] == null ? null : Snow.fromJson(json['snow'] as Map<String, dynamic>),
      clouds: Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
      sys: Sys.fromJson(json['sys'] as Map<String, dynamic>),
      dt: json['dt'] as int,
      timezone: json['timezone'] as int,
      name: json['name'] as String,
    );
  }

  @override
  String toString() {
    return "$name ${weather.temp}";
  }
}

class Coords {
  final double latitude;
  final double longitude;

  Coords({required this.latitude, required this.longitude});

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(latitude: json['lat'], longitude: json['lon']);
}

class Weather {
  final num id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class MainWeather {
  final num temp;
  final num feelsLike;
  final num tempMin;
  final num tempMax;
  final num pressure;
  final num humidity;
  final num? seaLevel;
  final num? grndLevel;

  MainWeather({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) => MainWeather(
        temp: json['temp'],
        feelsLike: json['feels_like'],
        tempMin: json['temp_min'],
        tempMax: json['temp_max'],
        pressure: json['pressure'],
        humidity: json['humidity'],
        seaLevel: json['sea_level'],
        grndLevel: json['grnd_level'],
      );
}

class Wind {
  final num speed;
  final num deg;
  final num? gust;

  Wind({required this.speed, required this.deg, required this.gust});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'] as num,
      deg: json['deg'] as num,
      gust: json['gust'] as num?,
    );
  }
}

class Rain {
  final num? oneHour;
  final num? threeHours;

  Rain({required this.oneHour, required this.threeHours});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      oneHour: json['1h'] as num?,
      threeHours: json['3h'] as num?,
    );
  }
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(all: json['all']);
  }
}

class Sys {
  final int id;
  final int type;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      type: json['type'] ?? 0,
      id: json['id'] ?? 0,
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class Snow {
  final num? oneHour;

  final num? threeHours;

  factory Snow.fromJson(final Map<String, dynamic> json) =>
      Snow(oneHour: json['1h'] as num?, threeHours: json['3h'] as num?);

  const Snow({
    required this.oneHour,
    required this.threeHours,
  });
}

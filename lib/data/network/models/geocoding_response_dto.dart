/// One result from Open-Meteo geocoding (https://geocoding-api.open-meteo.com).
///
/// `admin1` is the primary administrative region (state/region); it is absent
/// for some places, so it is nullable.
class GeocodingLocationDto {
  final String name;
  final String? admin1;
  final String country;
  final String countryCode;
  final double latitude;
  final double longitude;

  const GeocodingLocationDto({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    this.admin1,
  });

  factory GeocodingLocationDto.fromJson(final Map<String, dynamic> json) => GeocodingLocationDto(
        name: json['name'] as String,
        admin1: json['admin1'] as String?,
        country: json['country'] as String? ?? '',
        countryCode: json['country_code'] as String? ?? '',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
}

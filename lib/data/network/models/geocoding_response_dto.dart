class GeocodingLocationDto {
  final String name;
  final String? state;
  final String country;
  final num latitude;
  final num longitude;

  const GeocodingLocationDto({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.country,
    this.state,
  });

  factory GeocodingLocationDto.fromJson(final Map<String, dynamic> json) => GeocodingLocationDto(
        latitude: json['lat'] as num,
        longitude: json['lon'] as num,
        name: json['name'],
        state: json['state'],
        country: json['country'],
      );
}

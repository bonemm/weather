import 'package:geolocator/geolocator.dart';
import 'package:weather/data/network/models/geocoding_response_dto.dart';

class Location {
  final double latitude;
  final double longitude;
  final String location;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.location,
  });
  const Location.initial()
      : this(
          latitude: 43.485282,
          longitude: 43.606994,
          location: '',
        ); // default location - Vladikavkaz :)

  Location.fromPosition({required Position position})
      : this(
          latitude: position.latitude,
          longitude: position.longitude,
          location: '${(position.latitude * 100).round() / 100}:${(position.longitude * 100).round() / 100}',
        );

  factory Location.fromJson(final Map<String, dynamic> json) => Location(
        latitude: (json['latitude'] as double),
        longitude: (json['longitude'] as double),
        location: json['location'] as String,
      );

  factory Location.fromGeocodingResponse(GeocodingLocationDto geocodingResp) {
    String location = '${geocodingResp.name}, ${geocodingResp.country}';
    if (geocodingResp.country == 'US') {
      location += ', ${geocodingResp.state}';
    }
    return Location(
      latitude: geocodingResp.latitude.toDouble(),
      longitude: geocodingResp.longitude.toDouble(),
      location: location,
    );
  }

  Map<String, dynamic> toJson(Location geolocation) => <String, dynamic>{
        'longitude': geolocation.longitude,
        'latitude': geolocation.latitude,
        'location': geolocation.location,
      };

  Location copyWith({
    double? latitude,
    double? longitude,
    String? location,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
    );
  }
}

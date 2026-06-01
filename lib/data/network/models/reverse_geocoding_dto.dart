/// Reverse-geocoding result from BigDataCloud's free, keyless
/// `reverse-geocode-client` endpoint (https://www.bigdatacloud.com).
///
/// Used to turn the current GPS coordinates into a place name, since Open-Meteo
/// geocoding is forward-only. Fields can be empty over oceans or unmapped areas.
class ReverseGeocodingDto {
  final String city;
  final String countryCode;

  const ReverseGeocodingDto({required this.city, required this.countryCode});

  factory ReverseGeocodingDto.fromJson(final Map<String, dynamic> json) {
    // `city` is the populated-place name (e.g. "London"); fall back to the
    // smaller `locality` when `city` is blank.
    final city = (json['city'] as String?) ?? '';
    final locality = (json['locality'] as String?) ?? '';
    return ReverseGeocodingDto(
      city: city.isNotEmpty ? city : locality,
      countryCode: (json['countryCode'] as String?) ?? '',
    );
  }
}

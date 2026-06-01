import 'package:flutter/material.dart';

class PlaceName extends StatelessWidget {
  const PlaceName({super.key, required this.name, required this.countryCode});

  final String name;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    // No resolved place (e.g. reverse geocoding failed): show nothing.
    if (name.isEmpty) return const SizedBox.shrink();

    final label = countryCode.isEmpty ? name : '$name, $countryCode';
    return SizedBox(
      height: 30,
      child: Text(
        label,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

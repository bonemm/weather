import 'package:flutter/material.dart';

class PlaceName extends StatelessWidget {
  const PlaceName({super.key, required this.name, required this.countryCode});

  final String name;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Text(
        '$name, $countryCode',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

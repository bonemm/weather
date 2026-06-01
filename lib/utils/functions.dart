import 'package:intl/intl.dart';

// Format: "Monday, 25 Oct 14:30"
final _displayDateFormat = DateFormat('EEEE, dd MMM HH:mm');

String formatUnixTime(int unixUtcTime) {
  // Convert Unix timestamp to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(unixUtcTime * 1000, isUtc: true);
  return _displayDateFormat.format(date);
}

String formatDateTime(DateTime date) => _displayDateFormat.format(date);

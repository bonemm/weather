import 'package:intl/intl.dart';

String formatUnixTime(int unixUtcTime) {
  // Convert Unix timestamp to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(unixUtcTime * 1000, isUtc: true);

  // Format: "Monday, 25 Oct 14:30"
  return DateFormat('EEEE, dd MMM HH:mm').format(date);
}

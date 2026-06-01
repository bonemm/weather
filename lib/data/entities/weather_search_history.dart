import 'package:weather/data/entities/search_history_item_entity.dart';

class WeatherSearchHistory {
  final DateTime timestamp;
  final List<SearchHistoryEntry> entries;

  const WeatherSearchHistory({required this.timestamp, required this.entries});

  WeatherSearchHistory.initial() : this(timestamp: DateTime.now(), entries: []);

  WeatherSearchHistory removeEntry(SearchHistoryEntry entry) {
    final newList = entries.where((el) => el != entry).toList();
    return WeatherSearchHistory(
      timestamp: timestamp,
      entries: newList,
    );
  }

  WeatherSearchHistory addEntry(SearchHistoryEntry newEntry) {
    if (entries.contains(newEntry)) {
      return this;
    }
    final newList = List<SearchHistoryEntry>.from(entries)..add(newEntry);
    return WeatherSearchHistory(
      timestamp: timestamp,
      entries: newList,
    );
  }

  factory WeatherSearchHistory.fromJson(Map<String, dynamic> json) => WeatherSearchHistory(
      entries: (json['history'] as List<dynamic>)
          .map((e) => SearchHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Falls back to epoch so anything without a valid timestamp is treated as
      // stale and refreshed once.
      timestamp: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'history': entries,
        'date': timestamp.toIso8601String(),
      };
}

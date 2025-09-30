import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/weather_data.dart';

class StorageService {
  static const String _searchResultsKey = 'search_results';
  static const String _searchHistoryKey = 'search_history';

  static Future<void> saveSearchResults(List<WeatherData> searchResults) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = searchResults
          .map((weather) => weather.toJson())
          .toList();
      await prefs.setStringList(_searchResultsKey, jsonList);
    } catch (e) {
      print('Error saving search results: $e');
    }
  }

  static Future<List<WeatherData>> loadSearchResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_searchResultsKey) ?? [];

      return jsonList
          .map((jsonString) {
            try {
              return WeatherData.fromJsonString(jsonString);
            } catch (e) {
              print('Error parsing weather data: $e');
              return null;
            }
          })
          .where((weather) => weather != null)
          .cast<WeatherData>()
          .toList();
    } catch (e) {
      print('Error loading search results: $e');
      return [];
    }
  }

  static Future<void> saveSearchHistory(List<String> searchHistory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_searchHistoryKey, searchHistory);
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  static Future<List<String>> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_searchHistoryKey) ?? [];
    } catch (e) {
      print('Error loading search history: $e');
      return [];
    }
  }

  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchResultsKey);
      await prefs.remove(_searchHistoryKey);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  static Future<void> removeStaleData() async {
    try {
      final searchResults = await loadSearchResults();
      final freshResults = searchResults
          .where((weather) => !weather.isStale)
          .toList();
      await saveSearchResults(freshResults);
    } catch (e) {
      print('Error removing stale data: $e');
    }
  }
}

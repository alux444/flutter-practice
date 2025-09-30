import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApiService {
  static const String _baseUrl = "https://api.weatherapi.com/v1";

  static String get _apiKey {
    final key = dotenv.env['WEATHER_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('Weather API key not found in env file.');
    }
    return key;
  }

  static Future<Map<String, dynamic>?> getCurrentWeather({
    required String location,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/current.json?key=$_apiKey&q=$location');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Weather API error: (${response.statusCode}) ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    return getCurrentWeather(location: '$latitude,$longitude');
  }
}

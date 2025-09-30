import 'dart:convert';

class WeatherData {
  final String cityName;
  final String country;
  final double temperatureC;
  final double temperatureF;
  final double feelsLikeC;
  final double feelsLikeF;
  final String condition;
  final String iconUrl;
  final String lastUpdated;
  final double humidity;
  final double windKph;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperatureC,
    required this.temperatureF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.condition,
    required this.iconUrl,
    required this.lastUpdated,
    required this.humidity,
    required this.windKph,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['location']['name'],
      country: json['location']['country'],
      temperatureC: json['current']['temp_c'].toDouble(),
      temperatureF: json['current']['temp_f'].toDouble(),
      feelsLikeC: json['current']['feelslike_c'].toDouble(),
      feelsLikeF: json['current']['feelslike_f'].toDouble(),
      condition: json['current']['condition']['text'],
      iconUrl: json['current']['condition']['icon'],
      lastUpdated: json['current']['last_updated'],
      humidity: json['current']['humidity'].toDouble(),
      windKph: json['current']['wind_kph'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'country': country,
      'temperatureC': temperatureC,
      'temperatureF': temperatureF,
      'feelsLikeC': feelsLikeC,
      'feelsLikeF': feelsLikeF,
      'condition': condition,
      'iconUrl': iconUrl,
      'lastUpdated': lastUpdated,
      'humidity': humidity,
      'windKph': windKph,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      cityName: map['cityName'] ?? '',
      country: map['country'] ?? '',
      temperatureC: map['temperatureC']?.toDouble() ?? 0.0,
      temperatureF: map['temperatureF']?.toDouble() ?? 0.0,
      feelsLikeC: map['feelsLikeC']?.toDouble() ?? 0.0,
      feelsLikeF: map['feelsLikeF']?.toDouble() ?? 0.0,
      condition: map['condition'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      lastUpdated: map['lastUpdated'] ?? '',
      humidity: map['humidity']?.toDouble() ?? 0.0,
      windKph: map['windKph']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherData.fromJsonString(String source) =>
      WeatherData.fromMap(json.decode(source));

  bool get isStale {
    try {
      final lastUpdateTime = DateTime.parse(lastUpdated);
      final now = DateTime.now();
      return now.difference(lastUpdateTime).inMinutes > 30;
    } catch (e) {
      return true;
    }
  }
}

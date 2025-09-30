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
}

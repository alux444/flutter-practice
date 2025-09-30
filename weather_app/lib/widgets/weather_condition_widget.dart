import 'package:flutter/material.dart';
import 'package:weather_app/data/weather_data.dart';

class WeatherConditionWidget extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherConditionWidget({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            weatherData.cityName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ), // gets the headlineMedium theme and then adds bold font weight
          ),
          Text(
            weatherData.country,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),

          // weather icon + temp
          Row(
            children: [
              Image.network(
                weatherData.iconUrl,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.cloud, size: 100, color: Colors.grey);
                },
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    '${weatherData.temperatureC.round()}°C',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${weatherData.temperatureF.round()}°F',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // weather condition
          Text(
            weatherData.condition,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // weather details
          Container(),
          const SizedBox(height: 14),

          Text(
            'Last updated: ${weatherData.lastUpdated}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

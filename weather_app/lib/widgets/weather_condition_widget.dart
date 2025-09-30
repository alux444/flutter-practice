import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/data/weather_data.dart';
import 'package:weather_app/main.dart' show isIOS;

class WeatherConditionWidget extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherConditionWidget({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return _buildCupertinoWidget(context);
    }
    return _buildMaterialWidget(context);
  }

  Widget _buildMaterialWidget(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildCupertinoWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // City Name
        Text(
          weatherData.cityName,
          style: isIOS
              ? CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
              : Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),

        // Country
        Text(
          weatherData.country,
          style: isIOS
              ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemGrey,
                )
              : Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
        ),
        const SizedBox(height: 24),

        // Weather icon + temperature
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              weatherData.iconUrl,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  isIOS ? CupertinoIcons.cloud : Icons.cloud,
                  size: 100,
                  color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
                );
              },
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weatherData.temperatureC.round()}°C',
                  style: isIOS
                      ? CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle
                            .copyWith(fontSize: 48, fontWeight: FontWeight.bold)
                      : Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                ),
                Text(
                  '${weatherData.temperatureF.round()}°F',
                  style: isIOS
                      ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          color: CupertinoColors.systemGrey,
                        )
                      : Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[500],
                        ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Weather condition
        Text(
          weatherData.condition,
          style: isIOS
              ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )
              : Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Weather details
        _buildWeatherDetails(context),
        const SizedBox(height: 16),

        // Last updated
        Text(
          'Last updated: ${_formatDateTime(weatherData.lastUpdated)}',
          style: isIOS
              ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                )
              : Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isIOS ? CupertinoColors.systemGrey6 : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _WeatherDetailItem(
            icon: isIOS ? CupertinoIcons.drop : Icons.water_drop,
            label: 'Humidity',
            value: '${weatherData.humidity.round()}%',
            color: isIOS ? CupertinoColors.systemBlue : Colors.blue,
          ),
          _WeatherDetailItem(
            icon: isIOS ? CupertinoIcons.wind : Icons.air,
            label: 'Wind',
            value: '${weatherData.windKph.round()} km/h',
            color: isIOS ? CupertinoColors.systemGreen : Colors.green,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
}

class _WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _WeatherDetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: isIOS
              ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              : Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: isIOS
              ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                )
              : Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

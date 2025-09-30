import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/api/weather_api_service.dart';
import 'package:weather_app/src/location_service.dart';
import 'package:weather_app/data/weather_data.dart';
import 'package:weather_app/widgets/weather_condition_widget.dart';
import 'package:weather_app/main.dart' show isIOS;

class CityPage extends StatefulWidget {
  final String? cityName;

  const CityPage({super.key, this.cityName});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  String? currentCity;
  WeatherData? weatherData;
  bool isLoading = false;
  String? errorMessage;
  bool isUsingCustomCity = false;

  @override
  void initState() {
    super.initState();
    if (widget.cityName != null && widget.cityName!.isNotEmpty) {
      isUsingCustomCity = true;
      currentCity = widget.cityName;
      _getWeatherForCity(widget.cityName!);
      return;
    }
    _getCurrentLocationAndWeather();
  }

  Future<void> _getCurrentLocationAndWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      weatherData = null;
      isUsingCustomCity = false;
    });

    try {
      final city = await LocationService.getCurrentCity();
      if (city != null) {
        setState(() {
          currentCity = city;
        });
        await _getWeatherForCity(city);
        return;
      }

      setState(() {
        errorMessage = 'Failed to get current location :(';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error getting location: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _getWeatherForCity(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final weatherJson = await WeatherApiService.getCurrentWeather(
        location: city,
      );
      if (weatherJson != null) {
        setState(() {
          weatherData = WeatherData.fromJson(weatherJson);
          currentCity = weatherData!.cityName;
          isLoading = false;
        });
        return;
      }

      setState(() {
        errorMessage = 'Failed to fetch weather data for $city';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching weather: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _refreshWeather() {
    if (isUsingCustomCity && currentCity != null) {
      _getWeatherForCity(currentCity!);
      return;
    }
    _getCurrentLocationAndWeather();
  }

  void _switchToCurrentLocation() {
    _getCurrentLocationAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return _buildCupertinoPage();
    }
    return _buildMaterialPage();
  }

  Widget _buildMaterialPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUsingCustomCity ? 'Weather for $currentCity' : 'Current Weather',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (isUsingCustomCity)
            IconButton(
              onPressed: _switchToCurrentLocation,
              icon: const Icon(Icons.my_location),
              tooltip: 'Use current location',
            ),
          IconButton(
            onPressed: _refreshWeather,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh weather',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildCupertinoPage() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          isUsingCustomCity ? 'Weather for $currentCity' : 'Current Weather',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUsingCustomCity)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _switchToCurrentLocation,
                child: const Icon(CupertinoIcons.location_solid),
              ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _refreshWeather,
              child: const Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
      ),
      child: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isIOS
                ? const CupertinoActivityIndicator(radius: 20)
                : const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              isUsingCustomCity
                  ? 'Getting weather for ${widget.cityName}...'
                  : 'Getting your location and weather...',
              style: isIOS
                  ? CupertinoTheme.of(context).textTheme.textStyle
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isIOS
                    ? CupertinoIcons.exclamationmark_triangle
                    : Icons.error_outline,
                size: 80,
                color: isIOS ? CupertinoColors.systemRed : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Oops! Something went wrong',
                style: isIOS
                    ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                    : Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                style: TextStyle(
                  color: isIOS ? CupertinoColors.systemRed : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isIOS)
                    CupertinoButton.filled(
                      onPressed: _refreshWeather,
                      child: const Text('Try Again'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _refreshWeather,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  if (isUsingCustomCity) ...[
                    const SizedBox(width: 16),
                    if (isIOS)
                      CupertinoButton(
                        onPressed: _switchToCurrentLocation,
                        child: const Text('Use Location'),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: _switchToCurrentLocation,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Use Location'),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (weatherData != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (isUsingCustomCity)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isIOS
                      ? CupertinoColors.systemBlue.withOpacity(0.1)
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isIOS
                        ? CupertinoColors.systemBlue.withOpacity(0.3)
                        : Colors.blue[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isIOS ? CupertinoIcons.info : Icons.info_outline,
                      color: isIOS
                          ? CupertinoColors.systemBlue
                          : Colors.blue[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showing weather for custom city: ${weatherData!.cityName}',
                        style: TextStyle(
                          color: isIOS
                              ? CupertinoColors.systemBlue
                              : Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            WeatherConditionWidget(weatherData: weatherData!),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isIOS ? CupertinoIcons.cloud_snow : Icons.cloud_off,
            size: 80,
            color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            'No weather data available',
            style: TextStyle(
              fontSize: 16,
              color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

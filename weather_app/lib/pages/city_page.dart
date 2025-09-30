import 'package:flutter/material.dart';
import 'package:weather_app/api/weather_api_service.dart';
import 'package:weather_app/src/location_service.dart';
import 'package:weather_app/data/weather_data.dart';
import 'package:weather_app/widgets/weather_condition_widget.dart';

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
        errorMessage = 'Failed to fetch weather data :(';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Weather'),
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
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 14),
            Text(
              isUsingCustomCity
                  ? 'Getting weather for ${widget.cityName}...'
                  : 'Getting your location and weather...',
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Oops! Something went wrong :(',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _getCurrentLocationAndWeather,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (weatherData != null) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WeatherConditionWidget(weatherData: weatherData!),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No weather data available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

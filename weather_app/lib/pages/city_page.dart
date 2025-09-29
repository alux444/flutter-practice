import 'package:flutter/material.dart';
import 'package:weather_app/src/location_service.dart';

class CityPage extends StatefulWidget {
  const CityPage({super.key});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  String? currentCity;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final city = await LocationService.getCurrentCity();
      setState(() {
        currentCity = city;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to get location';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Weather'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Icon(Icons.location_city, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (errorMessage != null)
              Text(errorMessage!)
            else if (currentCity != null)
              Text(currentCity!)
            else
              Text('Couldn\'t get current city'),
          ],
        ),
      ),
    );
  }
}

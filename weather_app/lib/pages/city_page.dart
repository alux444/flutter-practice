import 'package:flutter/material.dart';

class CityPage extends StatelessWidget {
  const CityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Weather'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          children: [
            Icon(Icons.location_city, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text('Hello'),
          ],
        ),
      ),
    );
  }
}

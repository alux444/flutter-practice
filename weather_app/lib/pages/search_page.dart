import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          children: [
            Icon(Icons.search, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text('Search Page'),
            SizedBox(height: 10),
            Text('AAASDADCMDL'),
          ],
        ),
      ),
    );
  }
}

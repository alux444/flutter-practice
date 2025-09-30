import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/main.dart' show isIOS;

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return _buildCupertinoPage(context);
    }
    return _buildMaterialPage(context);
  }

  Widget _buildMaterialPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text('Search Page', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(
              'Search for cities will be implemented here',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoPage(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Search City')),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.search,
                size: 100,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(height: 20),
              Text(
                'Search Page',
                style: CupertinoTheme.of(
                  context,
                ).textTheme.navTitleTextStyle.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                'Search for cities will be implemented here',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

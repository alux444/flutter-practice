import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/main.dart' show isIOS;
import 'package:weather_app/api/weather_api_service.dart';
import 'package:weather_app/data/weather_data.dart';
import 'package:weather_app/pages/city_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<WeatherData> _searchResults = [];
  final List<String> _searchHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCity(String cityName) async {
    if (cityName.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weatherJson = await WeatherApiService.getCurrentWeather(
        location: cityName,
      );

      if (weatherJson != null) {
        final weatherData = WeatherData.fromJson(weatherJson);

        setState(() {
          final existingIndex = _searchResults.indexWhere(
            (item) =>
                item.cityName.toLowerCase() ==
                weatherData.cityName.toLowerCase(),
          );

          if (existingIndex != -1) {
            _searchResults[existingIndex] = weatherData; // Update existing
          } else {
            _searchResults.insert(0, weatherData); // Add new at top
          }

          if (!_searchHistory.contains(cityName)) {
            _searchHistory.insert(0, cityName);
            if (_searchHistory.length > 10) {
              _searchHistory.removeLast(); // Keep only last 10 searches
            }
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'City "$cityName" not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching for city: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    _searchCity(value);
  }

  void _clearResults() {
    setState(() {
      _searchResults.clear();
      _errorMessage = null;
    });
  }

  void _navigateToCityPage(WeatherData weatherData) {
    Navigator.push(
      context,
      isIOS
          ? CupertinoPageRoute(
              builder: (context) => CityPage(cityName: weatherData.cityName),
            )
          : MaterialPageRoute(
              builder: (context) => CityPage(cityName: weatherData.cityName),
            ),
    );
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
        title: const Text('Search Cities'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_searchResults.isNotEmpty)
            IconButton(
              onPressed: _clearResults,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear results',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildCupertinoPage() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Search Cities'),
        trailing: _searchResults.isNotEmpty
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _clearResults,
                child: const Icon(CupertinoIcons.clear),
              )
            : null,
      ),
      child: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Search Input
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildSearchInput(),
        ),

        // Loading indicator
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          ),

        // Error message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isIOS
                    ? CupertinoColors.systemRed.withOpacity(0.1)
                    : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isIOS
                      ? CupertinoColors.systemRed.withOpacity(0.3)
                      : Colors.red[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isIOS
                        ? CupertinoIcons.exclamationmark_triangle
                        : Icons.error_outline,
                    color: isIOS ? CupertinoColors.systemRed : Colors.red[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: isIOS
                            ? CupertinoColors.systemRed
                            : Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Search Results
        Expanded(
          child: _searchResults.isEmpty && !_isLoading && _errorMessage == null
              ? _buildEmptyState()
              : _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchInput() {
    if (isIOS) {
      return CupertinoSearchTextField(
        controller: _searchController,
        placeholder: 'Search for a city...',
        onSubmitted: _onSearchSubmitted,
      );
    } else {
      return TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for a city...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onSubmitted: _onSearchSubmitted,
        onChanged: (value) => setState(() {}),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isIOS ? CupertinoIcons.search : Icons.search,
            size: 100,
            color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            'Search for Cities',
            style: isIOS
                ? CupertinoTheme.of(
                    context,
                  ).textTheme.navTitleTextStyle.copyWith(fontSize: 24)
                : Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Enter a city name to see its current weather',
            style: TextStyle(
              fontSize: 16,
              color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),

          // Search History
          if (_searchHistory.isNotEmpty) ...[
            const SizedBox(height: 30),
            Text(
              'Recent Searches',
              style: isIOS
                  ? CupertinoTheme.of(
                      context,
                    ).textTheme.textStyle.copyWith(fontWeight: FontWeight.w600)
                  : Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _searchHistory.take(5).map((city) {
                return isIOS
                    ? CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        color: CupertinoColors.systemGrey6,
                        onPressed: () => _searchCity(city),
                        child: Text(
                          city,
                          style: const TextStyle(
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      )
                    : ActionChip(
                        label: Text(city),
                        onPressed: () => _searchCity(city),
                      );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final weatherData = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _navigateToCityPage(weatherData),
            child: _buildWeatherCard(weatherData),
          ),
        );
      },
    );
  }

  Widget _buildWeatherCard(WeatherData weatherData) {
    final cardContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Weather Icon
          Image.network(
            'https:${weatherData.iconUrl}',
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isIOS ? CupertinoIcons.cloud : Icons.cloud,
                size: 60,
                color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
              );
            },
          ),
          const SizedBox(width: 16),

          // City Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weatherData.cityName,
                  style: isIOS
                      ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      : Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  weatherData.country,
                  style: TextStyle(
                    color: isIOS
                        ? CupertinoColors.systemGrey
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weatherData.condition,
                  style: TextStyle(
                    color: isIOS
                        ? CupertinoColors.systemGrey
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Temperature
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${weatherData.temperatureC.round()}°C',
                style: isIOS
                    ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                    : Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '${weatherData.temperatureF.round()}°F',
                style: TextStyle(
                  color: isIOS ? CupertinoColors.systemGrey : Colors.grey[600],
                ),
              ),
            ],
          ),

          // Arrow indicator
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              isIOS ? CupertinoIcons.chevron_right : Icons.chevron_right,
              color: isIOS ? CupertinoColors.systemGrey : Colors.grey,
            ),
          ),
        ],
      ),
    );

    if (isIOS) {
      return Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: cardContent,
      );
    } else {
      return Card(elevation: 2, child: cardContent);
    }
  }
}

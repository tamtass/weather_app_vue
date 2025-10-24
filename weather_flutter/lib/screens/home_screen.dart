import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/weather_display.dart';
import '../widgets/weather_forecast_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Get weather for current location when app starts
    Future.microtask(
      () => context.read<WeatherProvider>().fetchWeatherByLocation(),
    );
  }

  void _handleSearch(String city) {
    if (city.isEmpty) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    } else {
      context.read<WeatherProvider>().fetchWeatherByCity(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (weatherProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weatherProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _handleSearch(''),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  WeatherSearchBar(onSearch: _handleSearch),
                  if (weatherProvider.weatherData != null) ...[
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 900) {
                            // Desktop layout
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: WeatherDisplay(
                                    weatherData: weatherProvider.weatherData!,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'Forecast',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: WeatherForecastList(
                                          forecast:
                                              weatherProvider
                                                  .weatherData!
                                                  .forecast,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Mobile layout
                            return ListView(
                              children: [
                                WeatherDisplay(
                                  weatherData: weatherProvider.weatherData!,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Forecast',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                WeatherForecastList(
                                  forecast:
                                      weatherProvider.weatherData!.forecast,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

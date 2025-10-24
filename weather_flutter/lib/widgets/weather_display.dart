import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDisplay({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              weatherData.cityName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM d, y').format(weatherData.time),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weatherData.icon}@2x.png',
                  width: 64,
                  height: 64,
                ),
                Text(
                  '${weatherData.temperature.round()}°C',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              weatherData.description.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  'Feels like',
                  '${weatherData.feelsLike.round()}°C',
                ),
                _buildWeatherDetail('Min', '${weatherData.tempMin.round()}°C'),
                _buildWeatherDetail('Max', '${weatherData.tempMax.round()}°C'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail('Humidity', '${weatherData.humidity}%'),
                _buildWeatherDetail('Pressure', '${weatherData.pressure} hPa'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';

class WeatherForecastList extends StatelessWidget {
  final List<WeatherForecast> forecast;

  const WeatherForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final item = forecast[index];
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              width: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(item.time),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(item.time),
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${item.icon}.png',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    '${item.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

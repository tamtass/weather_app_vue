import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const String _apiKey =
      '6bf1b019a26893adad5deb5b97a24c69'; // Replace with your OpenWeatherMap API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> getCurrentWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$city&units=metric&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final weatherData = WeatherData.fromJson(data);

      // Get forecast data
      final forecastResponse = await http.get(
        Uri.parse('$_baseUrl/forecast?q=$city&units=metric&appid=$_apiKey'),
      );

      if (forecastResponse.statusCode == 200) {
        final forecastData = json.decode(forecastResponse.body);
        final List<dynamic> forecastList = forecastData['list'];
        weatherData.forecast.addAll(
          forecastList.map((item) => WeatherForecast.fromJson(item)).toList(),
        );
      }

      return weatherData;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final weatherData = WeatherData.fromJson(data);

      // Get forecast data
      final forecastResponse = await http.get(
        Uri.parse(
          '$_baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$_apiKey',
        ),
      );

      if (forecastResponse.statusCode == 200) {
        final forecastData = json.decode(forecastResponse.body);
        final List<dynamic> forecastList = forecastData['list'];
        weatherData.forecast.addAll(
          forecastList.map((item) => WeatherForecast.fromJson(item)).toList(),
        );
      }

      return weatherData;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

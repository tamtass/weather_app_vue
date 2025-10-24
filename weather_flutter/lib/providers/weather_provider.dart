import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  String? _error;
  bool _isLoading = false;

  WeatherData? get weatherData => _weatherData;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchWeatherByCity(String city) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _weatherData = await _weatherService.getCurrentWeather(city);
    } catch (e) {
      _error = 'Failed to fetch weather data: ${e.toString()}';
      _weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _weatherData = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      _error = 'Failed to fetch weather data: ${e.toString()}';
      _weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

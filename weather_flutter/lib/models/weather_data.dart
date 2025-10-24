class WeatherData {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final String description;
  final String icon;
  final String cityName;
  final DateTime time;
  final List<WeatherForecast> forecast;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.time,
    required this.forecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      humidity: json['main']['humidity'] as int,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      cityName: json['name'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      forecast: [],
    );
  }
}

class WeatherForecast {
  final DateTime time;
  final double temperature;
  final String description;
  final String icon;

  WeatherForecast({
    required this.time,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }
}

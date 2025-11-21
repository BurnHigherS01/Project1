import 'package:intl/intl.dart';

class WeatherModel {
  final double temp; // current temperature
  final String city; // city name
  final String weatherState; // sunny, cloudy, etc.
  final double feelsLike; // apparent temperature
  final String sunrise;
  final String sunset;
  final List<String> hourly; // hourly temps 2AM-10AM
  final DateTime currentTime;

  WeatherModel({
    required this.temp,
    required this.city,
    required this.weatherState,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
    required this.hourly,
    required this.currentTime,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json, {
    required String cityName,
  }) {
    final current = json['current_weather'] ?? {};
    double temp = (current['temperature'] ?? 0).toDouble();
    int code = (current['weathercode'] ?? -1);
    String weatherState = _mapWeatherCode(code);

    // Feels like → take nearest hourly apparent_temperature if exists
    List hourlyTemps = json['hourly']?['apparent_temperature'] ?? [];
    List hourlyTimes = json['hourly']?['time'] ?? [];
    double feelsLike = temp;
    if (hourlyTemps.isNotEmpty) {
      feelsLike = hourlyTemps[0].toDouble();
    }

    String rawSunrise = (json["daily"]?["sunrise"]?[0] ?? "");
    String rawSunset = (json["daily"]?["sunset"]?[0] ?? "");

    String sunrise = _formatTime(rawSunrise);
    String sunset = _formatTime(rawSunset);

    // Hourly 2AM-10AM temperatures
    List<String> hourly = [];
    hourly.add(temp.toStringAsFixed(1)); // current temp
    int len = hourlyTemps.length < hourlyTimes.length
        ? hourlyTemps.length
        : hourlyTimes.length;

    for (int i = 0; i < len; i++) {
      try {
        DateTime time = DateTime.parse(hourlyTimes[i]);
        if (time.hour >= 2 && time.hour <= 10) {
          hourly.add(hourlyTemps[i].toStringAsFixed(1));
        }
      } catch (_) {
        continue;
      }
    }

    DateTime currentTime;
    try {
      currentTime = DateTime.parse(current['time']);
    } catch (_) {
      currentTime = DateTime.now();
    }

    return WeatherModel(
      temp: temp,
      city: cityName,
      weatherState: weatherState,
      feelsLike: feelsLike,
      sunrise: sunrise,
      sunset: sunset,
      hourly: hourly,
      currentTime: currentTime,
    );
  }

  static String _formatTime(String rawTime) {
    try {
      DateTime dt = DateTime.parse(rawTime);
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return "N/A";
    }
  }

  static String _mapWeatherCode(int code) {
    if ([0, 1].contains(code)) return "Sunny";
    if ([2, 3, 45, 48].contains(code)) return "Cloudy";
    if ([71, 73, 75, 77, 85, 86].contains(code)) return "Snowy";
    return "Rainy";
  }
}

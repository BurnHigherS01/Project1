import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? _weather;
  bool _isLoading = false;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;

  // Fetch weather and notify listeners
  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      _weather = await WeatherService().getWeatherData();
    } catch (e) {
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}

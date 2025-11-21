import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'dart:convert';
import '../location_check.dart';
import 'city_service.dart';

class WeatherService {
  Future<WeatherModel?> getWeatherData() async {
    try {
      final location = await LocationService.getLocation();
      final lat = location.latitude;
      final lon = location.longitude;

      // Get city name
      final cityName = await CityService().getCityName(lat, lon);

      // Fetch weather from Open-Meteo
      final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$lat&longitude=$lon"
        "&current_weather=true"
        "&hourly=temperature_2m,apparent_temperature"
        "&daily=sunrise,sunset"
        "&timezone=auto&forecast_days=1",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return WeatherModel.fromJson(jsonResponse, cityName: cityName);
      } else {
        return null;
      }
    } catch (e) {
      Text("WeatherService error: $e");
      return null;
    }
  }
}

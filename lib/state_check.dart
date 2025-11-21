import 'package:flutter/material.dart';

class StateCheck {
  // Define the color maps
  final Map<String, Map<String, dynamic>> _weatherColors = {
    "sunny": {
      "containerColor": Color(0xffFAE2BD),
      "textColor": Color(0xffEFAA82),
      "backgroundImage": "assets/sunnyScreen/SunnyBackground.png",
      "weatherImage": "assets/sunnyScreen/Sunny.png",
      "weatherAdvice" : "Bright sunshine greets the day with a warmth that gently encourages movement and cheer. Consider keeping yourself refreshed, for the hours may grow warmer than first expected. A calm stroll beneath the clear sky may reward you with unexpected comfort.",
    },
    "rainy": {
      "containerColor": Color(0xff40666A),
      "textColor": Color(0xffC9E8E0),
      "backgroundImage": "assets/rainyScreen/RainyBackground.png",
      "weatherImage": "assets/rainyScreen/Rainy.png",
      "weatherAdvice" : "Soft rain settles upon the day with a steady patience that asks for thoughtful preparation. Carrying an umbrella may spare you needless trouble along your path. The air holds a renewed scent that invites quiet reflection as you move.",
    },
    "snowy": {
      "containerColor": Color(0xffA7ACC4),
      "textColor": Color(0xffE2E2E3),
      "backgroundImage": "assets/snowyScreen/SnowyBackground.png",
      "weatherImage": "assets/snowyScreen/snowCloud.png",
      "weatherAdvice" : "Snow drifts lightly across the morning, lending a still charm yet urging care in every step. Warm layers will serve you well as the cold lingers longer than it admits. Such weather, though brisk, offers a peaceful beauty to those who notice.",
    },
    "cloudy": {
      "containerColor": Color(0xff91B4C6),
      "textColor": Color(0xffCAD7DF),
      "backgroundImage": "assets/cloudyScreen/CloudyBackground.png",
      "weatherImage": "assets/cloudyScreen/Cloud.png",
      "weatherAdvice" : "Gentle clouds gather overhead as though the sky moves in quiet contemplation. The day remains calm, though a sudden change may visit without warning. Light attire suits the moment, while mindful attention brings ease through its softness.",
    },
  };

  // Default state if weatherState not found
  final String _defaultState = "cloudy";

  /// Returns the color map for the given weather state
  Map<String, dynamic> getColors(String weatherState) {
    return _weatherColors[weatherState.toLowerCase()] ??
        _weatherColors[_defaultState]!;
  }

  /// Convenience getters
  Color getContainerColor(String weatherState) {
    return getColors(weatherState)["containerColor"]!;
  }

  Color getTextColor(String weatherState) {
    return getColors(weatherState)["textColor"]!;
  }

  String getBackgroundImage(String weatherState) {
    return getColors(weatherState)["backgroundImage"];
  }

  String getWeatherImage(String weatherState) {
    return getColors(weatherState)["weatherImage"];
  }

  String getAdvice(String weatherState) {
    return getColors(weatherState)["weatherAdvice"];
  }
}

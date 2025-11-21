import 'package:flutter/material.dart';
import 'package:weather_app_ui/location_gate.dart';
import 'screens/Weather_api_demo.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationGatee(child: WeatherApiDemo()),
    );
  }
}
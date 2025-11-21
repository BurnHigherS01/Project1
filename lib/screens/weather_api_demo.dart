import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:weather_app_ui/services/weather_service.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../state_check.dart';

class WeatherApiDemo extends StatefulWidget {
  static const List<String> weatherTime = [
    "Now",
    "2 AM",
    "3 AM",
    "4 AM",
    "5 AM",
  ];
  static const List<String> weatherTime2 = [
    "6 AM",
    "7 AM",
    "8 AM",
    "9 AM",
    "10 AM",
  ];
  const WeatherApiDemo({super.key});

  @override
  State<WeatherApiDemo> createState() => _WeatherApiDemoState();
}

class _WeatherApiDemoState extends State<WeatherApiDemo> {
  @override
  void initState() {
    super.initState();
    // Fetch weather when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final weather = provider.weather;

        if (weather == null) {
          return const Center(child: Text("Failed to load weather"));
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: FutureBuilder(
            future: WeatherService().getWeatherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text("Failed to load weather"));
              } else {
                final weather = snapshot.data!;
                final stateCheck = StateCheck();
                final containerColor = stateCheck.getContainerColor(
                  weather.weatherState,
                );
                final textColor = stateCheck.getTextColor(weather.weatherState);
                final backgroundImage = stateCheck.getBackgroundImage(
                  weather.weatherState,
                );
                final weatherImage = stateCheck.getWeatherImage(
                  weather.weatherState,
                );
                final weatherAdvice = stateCheck.getAdvice(
                  weather.weatherState,
                );
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 53,
                      child: Container(
                        width: 360,
                        height: 386,
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 78,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Today",
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: textColor,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Image.asset(
                                weatherImage,
                                color: textColor,
                                width: 95,
                                height: 72,
                              ),
                              SizedBox(width: 20),
                              Text(
                                weather.temp.toInt().toString(),
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 100,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 90.0),
                                child: Image.asset(
                                  "assets/cloudyScreen/degreeCeluis.png",
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            weather.weatherState,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            weather.city,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            DateFormat(
                              'dd MMM yyyy',
                            ).format(weather.currentTime),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Feels like ${weather.feelsLike.toInt()}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 1,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: textColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Sunset ${weather.sunset}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 474,
                      width: 360,
                      height: 193,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 360,
                            height: 193,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: RadialGradient(
                                colors: [
                                  containerColor,
                                  containerColor.withValues(alpha: 0.5),
                                ],
                                stops: [0, 1],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(
                                      WeatherApiDemo.weatherTime.length,
                                      (index) {
                                        final timeLabel =
                                            WeatherApiDemo.weatherTime[index];
                                        final temp = weather
                                            .hourly[index]; // Use correct hourly temp
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              timeLabel,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  "assets/cloudyScreen/Cloud.png",
                                                  width: 16,
                                                  height: 12,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  temp.split(".")[0],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 12.0,
                                                        left: 1,
                                                      ),
                                                  child: Image.asset(
                                                    "assets/cloudyScreen/degreeCeluis.png",
                                                    width: 4,
                                                    height: 4,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 300,
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(
                                      WeatherApiDemo.weatherTime2.length,
                                      (index) {
                                        final timeLabel =
                                            WeatherApiDemo.weatherTime2[index];
                                        final temp =
                                            weather.hourly[WeatherApiDemo
                                                    .weatherTime
                                                    .length +
                                                index]; // Offset by first part
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              timeLabel,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  "assets/cloudyScreen/Cloud.png",
                                                  width: 16,
                                                  height: 12,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  temp.split(".")[0],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 12.0,
                                                        left: 1,
                                                      ),
                                                  child: Image.asset(
                                                    "assets/cloudyScreen/degreeCeluis.png",
                                                    width: 4,
                                                    height: 4,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Positioned(
                      top: 700,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Weather Advice',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(height: 18),

                          Container(
                            width: 349,
                            // ✅ Add this
                            child: Text(
                              weatherAdvice,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}

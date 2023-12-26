import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/api_service/weather_service.dart';
import 'package:weatherwise/models/weather_model.dart';

import '../constants/constants.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService(kAPIKey);
  Weather? cityWeather;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (cityWeather != null)
                  ? cityWeather!.cityName
                  : 'Loading city Name...',
            ),
            Lottie.asset('assets/cloud.json'),
            Text(
              (cityWeather != null)
                  ? '${cityWeather!.temperature.round()} °C'
                  : 'loading temperature...',
            ),
          ],
        ),
      ),
    );
  }

  getCurrentWeather() async {
    String cityName = await weatherService.getCurrentCity();
    debugPrint('Current city is $cityName');
    try {
      final weather = await weatherService.getWeather(cityName);
      setState(() {
        cityWeather = weather;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/api_service/weather_service.dart';
import 'package:weatherwise/models/weather_model.dart';

import '../constants/constants.dart';
import '../widgets/loading_weather.dart';

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
        child: (cityWeather != null)
            ? weatherDetails()
            : const LoadingWeatherData(),
      ),
    );
  }

  Column weatherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          (cityWeather != null)
              ? cityWeather!.cityName
              : 'Loading city Name...',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Lottie.asset(
          getWeatherAnimation(
            cityWeather!.weatherCondition,
          ),
        ),
        Text(
          (cityWeather != null)
              ? '${(cityWeather!.temperature.round() - 273.15).toStringAsFixed(1)} °C'
              : 'loading temperature...',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }
}

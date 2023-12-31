import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weatherwise/api_service/weather_service.dart';
import 'package:weatherwise/models/weather_model.dart';
import 'package:weatherwise/provider/theme_provider.dart';

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
  TextEditingController cityNameController = TextEditingController();
  bool isSearched = false;
  bool isAPICallProcess = false;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (cityWeather != null && isAPICallProcess == false)
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: 20,
                      right: 20,
                    ),
                    child: SearchBar(
                      controller: cityNameController,
                      hintText: 'Search City.',
                      onSubmitted: (val) {
                        cityNameController.text = val;
                        isSearched = true;
                        getWeatherForTheCitySearched(cityNameController.text);
                        if (cityNameController.text.isEmpty) {
                          getCurrentWeather();
                        }
                      },
                      trailing: [
                        IconButton(
                          tooltip: 'Search',
                          onPressed: () {
                            isSearched = !isSearched;
                            if (isSearched == false) {
                              getCurrentWeather();
                              setState(() {
                                cityNameController.clear();
                              });
                            } else {
                              getWeatherForTheCitySearched(
                                cityNameController.text,
                              );
                            }
                          },
                          icon: Icon(
                            (isSearched == false) ? Icons.search : Icons.clear,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: weatherDetails(),
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, ThemeProvider themeProvider, child) =>
                        Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            themeProvider.isDark ? 'Light Theme' : 'Dark Theme',
                          ),
                          IconButton(
                            icon: Icon(
                              themeProvider.isDark
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny,
                              color: themeProvider.isDark
                                  ? Colors.grey
                                  : Colors.yellow,
                            ),
                            onPressed: () {
                              themeProvider.isDark
                                  ? themeProvider.isDark = false
                                  : themeProvider.isDark = true;
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
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
            fontSize: 20,
            fontWeight: FontWeight.w700,
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  getWeatherForTheCitySearched(String cityName) async {
    try {
      setState(() {
        isAPICallProcess = true;
      });
      final weather = await weatherService.getWeather(cityName);
      setState(() {
        cityWeather = weather;
        isAPICallProcess = false;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  getCurrentWeather() async {
    String cityName = await weatherService.getCurrentCity();
    debugPrint('Current city is $cityName');
    try {
      setState(() {
        isAPICallProcess = true;
      });
      final weather = await weatherService.getWeather(cityName);
      setState(() {
        cityWeather = weather;
        isAPICallProcess = false;
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

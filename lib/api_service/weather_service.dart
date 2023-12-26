import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherwise/constants/constants.dart';

import '../models/weather_model.dart';

class WeatherService {
  String kAPIKey = 'YOUR API KEY';
  WeatherService(this.kAPIKey);
  getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$apiDomain?q=$cityName&appid=$kAPIKey'
          // 'https://api.openweathermap.org/data/2.5/weather?q=ranchi&appid=2c8c649b1001b3e64baae463d1bda66c'
          ),
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return Weather.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Unable to load weather data at the moment.');
    }
  }

  getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;

    return city ?? '';
  }
}

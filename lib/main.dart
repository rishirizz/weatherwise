import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherwise/pages/weather_page.dart';
import 'package:weatherwise/provider/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: (themeProvider.isDark)
              ? ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.purple,
                    brightness: Brightness.dark,
                  ),
                )
              : ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                  ),
                  useMaterial3: true,
                ),
          home: const WeatherPage(),
        ),
      ),
    );
  }
}

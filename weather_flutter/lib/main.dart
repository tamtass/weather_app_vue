import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFF98D7C2),
            onPrimary: Colors.black,
            secondary: Color(0xFF98D7C2),
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            background: Color(0xFF333333),
            onBackground: Colors.white,
            surface: Color(0xFF424242),
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: Color(0xFF333333),
          cardColor: Color(0xFF424242),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

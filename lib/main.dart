import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'screens/my_home_page.dart';


Color red = const Color(0xFF80D8FF);
Color blue = const Color(0xFFFF8A80);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(const WeatherApp());
  });
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather_proj',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 225, 117, 22),
          secondary: Color.fromARGB(170, 19, 20, 22),
        ),
      ),
      home: const MyHomePage(title: 'Weather_proj'),

      debugShowCheckedModeBanner: false,
    );
  }
}


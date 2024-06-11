import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';


StreamController<bool> permissionController = StreamController<bool>();

Future<void> getLocation() async {
  try {
    await _determinePosition();
  } catch (e) {
    print('An error occurred: $e');
  }
}

Future<bool> _determinePosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    } else {
      permissionController.add(true);
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  print('Location permissions are granted');
  return true;
}

Stream<Position?> positionStream() async* {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print('\x1B[33mserviceEnabled: $serviceEnabled\x1B[0m');
  if (!serviceEnabled) {
    yield null;
  } else {
    yield await Geolocator.getCurrentPosition();
  }
  await Future.delayed(const Duration(seconds: 360));
}

Map<int, String> weatherCodeMap = {
  0: 'Clear sky',
  1: 'Mainly clear',
  2: 'Partly cloudy',
  3: 'Overcast',
  45: 'Fog',
  48: 'Depositing rime fog',
  51: 'Light drizzle',
  53: 'Moderate drizzle',
  55: 'Dense drizzle',
  56: 'Light freezing drizzle',
  57: 'Dense freezing drizzle',
  61: 'Slight rain',
  63: 'Moderate rain',
  65: 'Heavy rain',
  66: 'Light freezing rain',
  67: 'Heavy freezing rain',
  71: 'Slight snow fall',
  73: 'Moderate snow fall',
  75: 'Heavy snow fall',
  77: 'Snow grains',
  80: 'Slight rain showers',
  81: 'Moderate rain showers',
  82: 'Violent rain showers',
  85: 'Slight snow showers',
  86: 'Heavy snow showers',
  95: 'Slight or moderate thunderstorm',
  96: 'Thunderstorm with slight hail',
  99: 'Thunderstorm with heavy hail',
};

Map<int, IconData> weatherIconMap = {
  0: Icons.sunny,
  1: Icons.cloud,
  2: Icons.cloud,
  3: Icons.cloud,
  45: Icons.foggy,
  48: Icons.foggy,
  51: Icons.water_drop,
  53: Icons.water_drop,
  55: Icons.water_drop,
  56: Icons.snowing,
  57: Icons.snowing,
  61: Icons.water_drop,
  63: Icons.water_drop,
  65: Icons.water_drop,
  66: Icons.water_drop,
  67: Icons.water_drop,
  71: Icons.snowing,
  73: Icons.snowing,
  75: Icons.snowing,
  77: Icons.snowing,
  80: Icons.water_drop,
  81: Icons.water_drop,
  82: Icons.water_drop,
  85: Icons.snowing,
  86: Icons.snowing,
  95: Icons.thunderstorm,
  96: Icons.thunderstorm,
  99: Icons.thunderstorm
};

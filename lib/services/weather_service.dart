
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import 'dart:convert';


Future<City> fetchWeatherData(City? city, ValueNotifier<String?> errorMessage) async {
  final weatherInfo = await http.get(Uri.parse(
    'https://api.open-meteo.com/v1/forecast?'
        'latitude=${city?.latitude}&'
        'longitude=${city?.longitude}&'
        'current=temperature_2m,weather_code,wind_speed_10m&'
        'hourly=temperature_2m,wind_speed_10m&'
        'daily=weather_code,temperature_2m_max,temperature_2m_min&'
        'forecast_days=7',
  ));
  Map<String, dynamic> data = jsonDecode(weatherInfo.body);
  if (weatherInfo.statusCode == 200 && city != null) {
    return City(
      name: city.name,
      region: city.region,
      country: city.country,
      latitude: city.latitude,
      longitude: city.longitude,
      windSpeed: data['current']['wind_speed_10m'] ?? '',
      temperature: data['current']['temperature_2m'] ?? '',
      weatherCode: data['current']['weather_code'] ?? '',
      time: List<String>.from(data['hourly']['time'] ?? []),
      hourlyTemperature: List<double>.from(data['hourly']['temperature_2m'] ?? []),
      hourlyWindSpeed: List<double>.from(data['hourly']['wind_speed_10m'] ?? []),
      days: List<String>.from(data['daily']['time'] ?? []),
      minDailyTemperature: List<double>.from(data['daily']['temperature_2m_min'] ?? []),
      maxDailyTemperature: List<double>.from(data['daily']['temperature_2m_max'] ?? []),
      dailyWeatherCode: List<int>.from(data['daily']['weather_code'] ?? []),
    );
  } else {
    City currentCity = await fetchCurrentCityData();
    currentCity.windSpeed = data['current']['wind_speed_10m'] ?? '';
    currentCity.temperature = data['current']['temperature_2m'] ?? '';
    currentCity.weatherCode = data['current']['weather_code'] ?? '';
    currentCity.time = List<String>.from(data['hourly']['time'] ?? []);
    currentCity.hourlyTemperature = List<double>.from(data['hourly']['temperature_2m'] ?? []);
    currentCity.hourlyWindSpeed = List<double>.from(data['hourly']['wind_speed_10m'] ?? []);
    currentCity.days = List<String>.from(data['daily']['time'] ?? []);
    currentCity.minDailyTemperature = List<double>.from(data['daily']['temperature_2m_min'] ?? []);
    currentCity.maxDailyTemperature = List<double>.from(data['daily']['temperature_2m_max'] ?? []);
    currentCity.dailyWeatherCode = List<int>.from(data['daily']['weather_code'] ?? []);
    return currentCity;
  }
}

Future<City> fetchWeatherDataSafe(City? city, ValueNotifier<String?> errorMessage) async {
  city ??= await fetchCurrentCityData();
  return fetchWeatherData(city, errorMessage);
}

Future<List<City>> fetchCitiesData(String query) async {
  final nameInfo = await http.get(Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?'
          'name=$query&'
          'count=5&'
          'language=en&'
          'format=json'));
  if (nameInfo.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(nameInfo.body);
    if (data['results'] != null && data['results'] is List) {
      List<dynamic> results = data['results'];
      List<City> cityList = [];
      for (var city in results) {
        cityList.add(City(
          name: city['name'] ?? '',
          region: city['admin1'] ?? '',
          country: city['country'] ?? '',
          latitude: city['latitude'] ?? '',
          longitude: city['longitude'] ?? '',
        ));
      }
      return cityList;
    } else {
      throw Exception('Failed to load weather data');
    }
  } else {
    throw Exception('Failed to load city names');
  }
}

Future<City> fetchCurrentCityData() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  final dataInfo = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m'
  ));
  Placemark placemark = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
  Map<String, dynamic> data = jsonDecode(dataInfo.body);
  print("\x1B32[mDataInfo: ${dataInfo.body}\x1B[0m");
  if (dataInfo.statusCode != 200 || data['latitude'] == null || data['longitude'] == null) {
    throw Exception('Failed to load weather data');
  }
  return City(
    name: placemark.locality.toString(),
    region: placemark.administrativeArea.toString(),
    country: placemark.country.toString(),
    latitude: data['latitude'],
    longitude: data['longitude'],
    windSpeed: data['current']['wind_speed_10m'] ?? '',
    temperature: data['current']['temperature_2m'] ?? '',
    weatherCode: data['current']['weather_code'] ?? '',
  );
}

Future<City> fetchTextInputCityData(String text) {
  return fetchCitiesData(text).then((value) => value[0]);
}
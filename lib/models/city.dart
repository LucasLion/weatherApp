
class City {
  String name;
  String region;
  String country;
  double latitude;
  double longitude;
  double? windSpeed;
  double? temperature;
  int? weatherCode;

  List<String> time;
  List<double> hourlyTemperature;
  List<double> hourlyWindSpeed;

  List<String> days;
  List<double> minDailyTemperature;
  List<double> maxDailyTemperature;
  List<int> dailyWeatherCode;


  City({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.windSpeed,
    this.temperature,
    this.weatherCode,
    this.time = const [],
    this.hourlyTemperature = const [],
    this.hourlyWindSpeed = const [],
    this.days = const [],
    this.minDailyTemperature = const [],
    this.maxDailyTemperature = const [],
    this.dailyWeatherCode = const [],
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      region: json['admin1'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      windSpeed: json['current']['wind_speed_10m'] ?? '',
      temperature: json['current']['temperature_2m'] ?? '',
      weatherCode: json['current']['weather_code'] ?? '',
      time: List<String>.from(json['hourly']['time'] ?? []),
      hourlyTemperature: List<double>.from(json['hourly']['temperature_2m'] ?? []),
      hourlyWindSpeed: List<double>.from(json['hourly']['wind_speed_10m'] ?? []),
      days: List<String>.from(json['daily']['time'] ?? []),
      minDailyTemperature: List<double>.from(json['daily']['temperature_2m_min'] ?? []),
      maxDailyTemperature: List<double>.from(json['daily']['temperature_2m_max'] ?? []),
      dailyWeatherCode: List<int>.from(json['daily']['weather_code'] ?? []),
    );
  }
}

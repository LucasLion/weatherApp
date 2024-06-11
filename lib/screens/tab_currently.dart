
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';
import '../utils/utils.dart';

class TabCurrently extends StatelessWidget {
  final City city;

  const TabCurrently({super.key, required this.city});

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Tab(
      child: Padding(
        padding: EdgeInsets.only(top: height / 14),
        child: Column(
          children: [
            Text(
              city.name,
              style: GoogleFonts.bebasNeue(
                textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.blue),
              ),
            ),
            Text(
                "${city.region}, ${city.country}",
                style: GoogleFonts.bebasNeue(
                  textStyle: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: height / 12, bottom: height / 12),
              child: Text(
                '${city.temperature.toString()}°C',
                style: GoogleFonts.bebasNeue(
                  textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.primary), fontSize: 70,
                ),
              ),
            ),
            Text(
              '${weatherCodeMap[city.weatherCode]}',
              style: GoogleFonts.bebasNeue(
                textStyle: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Icon(city.weatherCode != null ? weatherIconMap[city.weatherCode]! : Icons.error, color: Colors.blue, size: 50),
            Padding(
              padding: EdgeInsets.only(top: height / 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.air, color: Colors.blue, size: 30),
                  Text(
                    '  ${city.windSpeed.toString()} km/h',
                    style: GoogleFonts.bebasNeue(
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
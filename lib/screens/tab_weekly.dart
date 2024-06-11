import 'package:flutter/material.dart';
import 'package:weather_proj/widgets/WeeklyChart.dart';
import '../models/city.dart';
import '../widgets/WeeklyList.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWeekly extends StatelessWidget {
  final City city;

  const TabWeekly({super.key, required this.city});

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Flex(
        direction: Axis.vertical,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        city.name,
                        style: GoogleFonts.bebasNeue(
                            textStyle: Theme.of(context).textTheme.displaySmall).copyWith(color: Colors.blue),
                      ),
                      Text(
                        "${city.region}, ${city.country}",
                        style: GoogleFonts.bebasNeue(
                            textStyle: Theme.of(context).textTheme.displaySmall
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: WeeklyChart(city: city)),
                  ),
                  Flexible(flex: 2, child: WeeklyList(city: city)),
                ]
              ),
            ),
          ],
        )
      );
  }
}
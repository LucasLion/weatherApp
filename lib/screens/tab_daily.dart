import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';
import '../utils/utils.dart';
import '../widgets/DailyChart.dart';
import '../widgets/DailyList.dart';

class TabDaily extends StatelessWidget {
  final City city;

  const TabDaily({super.key, required this.city});

  Column _names(BuildContext context) {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 1, // This child will take 1/6 of the available space
            child: Column(
              children: [
                _names(context),
                Flexible(
                  flex: 3, // This child will take 3/6 of the available space
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DailyChart(city: city)),
                ),
                Flexible(
                  flex: 2, // This child will take 2/6 of the available space
                  child: DailyList(city: city),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
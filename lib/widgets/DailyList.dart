import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';
import '../utils/utils.dart';

class DailyList extends StatelessWidget {
  final City city;
  final ScrollController _scrollController = ScrollController();

  DailyList({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbColor: Theme.of(context).colorScheme.primary,
      trackVisibility: false,
      thickness: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ListView.builder(
            itemCount: 24,
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.white70.withOpacity(0.05),
                    )
                  ),
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(city.time[index].substring(11),
                          style: GoogleFonts.bebasNeue(
                            textStyle: Theme.of(context).textTheme.displaySmall,
                            fontSize: 25,
                          ),
                        ),
                        Icon(city.weatherCode != null ? weatherIconMap[city.weatherCode]! : Icons.error, color: Colors.blue, size: 30),
                        Text('${city.hourlyTemperature[index].toString()}℃',
                          style: GoogleFonts.bebasNeue(
                            textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.primary)
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.air, color: Colors.white70, size: 20),
                            Text('  ${city.hourlyWindSpeed[index].toString()} km/h',
                              style: GoogleFonts.bebasNeue(
                                textStyle: Theme.of(context).textTheme.displaySmall,
                                fontSize: 20,

                              ),
                            ),
                          ],
                        )
                      ],
                                       ),
                   ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
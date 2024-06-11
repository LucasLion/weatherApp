import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/city.dart';
import '../utils/utils.dart';
import '../main.dart';

class WeeklyList extends StatelessWidget {
  final City city;
  final ScrollController _scrollController = ScrollController();

  WeeklyList({super.key, required this.city});

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
            itemCount: city.days.length,
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
                        // text date
                        Text(
                          DateFormat('dd/MM').format(DateFormat('yyyy-MM-dd').parse(city.days[index])),
                          style: GoogleFonts.bebasNeue(
                            textStyle: Theme.of(context).textTheme.displaySmall,
                            fontSize: 25,
                          ),
                        ),
                        Icon(city.dailyWeatherCode[index] != null ? weatherIconMap[city.dailyWeatherCode[index]]! : Icons.error, color: Colors.white70, size: 30),
                        Row(
                          children: [
                            Text(
                              '${city.maxDailyTemperature[index].toString()}℃',
                              style: TextStyle(
                                color: blue,
                                fontSize: 25,
                              )
                            ),
                            Text(
                              ' max',
                              style: TextStyle(
                                color: blue,
                                fontSize: 15,
                              )
                            )
                          ]
                        ),
                        Row(
                            children: [
                              Text(
                                  '${city.minDailyTemperature[index].toString()}℃',
                                  style: TextStyle(
                                    color: red,
                                    fontSize: 25,
                                  )
                              ),
                              Text(
                                  ' min',
                                  style: TextStyle(
                                    color: red,
                                    fontSize: 15,
                                  )
                              )
                            ]
                        ),
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
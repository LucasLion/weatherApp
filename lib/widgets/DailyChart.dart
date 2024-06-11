import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/city.dart';

class DailyChart extends StatelessWidget {
  final City city;

  const DailyChart({super.key, required this.city});

  double _getMaxTemperatureThreshold() {
    double max = city.hourlyTemperature[0];
    for (int i = 0; i < 24; i++) {
      if (city.hourlyTemperature[i] > max) {
        max = city.hourlyTemperature[i];
      }
    }
    return max + 2;
  }

  double _getMinTemperatureThreshold() {
    double min = city.hourlyTemperature[0];
    for (int i = 0; i < 24; i++) {
      if (city.hourlyTemperature[i] < min) {
        min = city.hourlyTemperature[i];
      }
    }
    return min - 4;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white70.withOpacity(0.05),
            ),
        ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Today Temperatures',
                      style: GoogleFonts.bebasNeue(
                        textStyle: Theme.of(context).textTheme.displaySmall,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        clipData: const FlClipData.all(),
                        minY: _getMinTemperatureThreshold(),
                        maxY: _getMaxTemperatureThreshold(),
                        borderData: FlBorderData(
                          border: Border.all(
                            color: Colors.white70,
                          )
                        ),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 2,
                          verticalInterval: 3,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            color: Colors.white70,
                            strokeWidth: 1,
                            dashArray: [6, 6],
                          ),
                          getDrawingVerticalLine: (value) => const FlLine(
                            color: Colors.white70,
                            strokeWidth: 1,
                            dashArray: [6, 6],
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (int i = 0; i < 24; i++)
                                FlSpot(i.toDouble(), city.hourlyTemperature[i].toDouble()),
                            ],
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            preventCurveOverShooting: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) => FlDotCirclePainter(
                                radius: 3,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            shadow: const Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                            ),
                          )
                        ],
                        lineTouchData: const LineTouchData(
                          touchSpotThreshold: 5,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(
                            showTitles: false,
                          )),
                          topTitles: const AxisTitles(sideTitles: SideTitles(
                            showTitles: false,
                          )),
                          leftTitles: AxisTitles(sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            reservedSize: 40,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value == meta.min || value == meta.max) {
                                return Container();
                              }
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    '${value.toInt().toString()}°C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              );
                            },
                          )),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 3,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value == meta.max) {
                                return Container();
                              }
                              String text = '${value.toInt() < 10 ? '0${value.toInt()}' : value.toInt()}:00';

                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          )
                        ),
                      ),
                    ),
                  )
                          ),
                ],
              ),
            ),
          )]
      ),
    );
  }
}

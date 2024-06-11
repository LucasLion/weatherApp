import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/city.dart';
import '../main.dart';


class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Container(
              height: 3,
              width: 20,
              color: color,
            ),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
class TemperatureLegend extends StatelessWidget {
  const TemperatureLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LegendItem(
          color: blue,
          text: 'Min temperature',
        ),
        const SizedBox(width: 20),
        LegendItem(
          color: red,
          text: 'Max temperature',
        ),
      ],
    );
  }
}


class WeeklyChart extends StatelessWidget {
  final City city;

  const WeeklyChart({super.key, required this.city});


  double _getMaxTemperatureThreshold() {
    double max = city.maxDailyTemperature[0];
    for (int i = 0; i < 7; i++) {
      if (city.maxDailyTemperature[i] > max) {
        max = city.maxDailyTemperature[i];
      }
    }
    return max + 3;
  }

  double _getMinTemperatureThreshold() {
    double min = city.minDailyTemperature[0];
    for (int i = 0; i < 7; i++) {
      if (city.minDailyTemperature[i] < min) {
        min = city.minDailyTemperature[i];
      }
    }
    return min - 3;
  }

  @override
  Widget build(BuildContext context) {
    if (city.maxDailyTemperature.length < 8) {
      city.maxDailyTemperature.add(city.maxDailyTemperature[6]);
    }
    if (city.minDailyTemperature.length < 8) {
      city.minDailyTemperature.add(city.minDailyTemperature[6]);
    }
    print('\x1B[33mmaxDailyTemperature: ${city.maxDailyTemperature.toString()}\x1B[0m');
    print('\x1B[33mminDailyTemperature: ${city.minDailyTemperature.toString()}\x1B[0m');
    // print len
    print('\x1B[33mlen maxDailyTemperature: ${city.maxDailyTemperature.length}\x1B[0m');
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Weekly Temperatures',
                      style: GoogleFonts.bebasNeue(
                        textStyle: Theme.of(context).textTheme.displaySmall,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                      double width = constraints.maxWidth;
                      double padding = width / 15;
                      return LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(
                              showTitles: true,
                              interval: 5,
                              reservedSize: 50,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == meta.min || value == meta.max) {
                                  return Container();
                                }
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    '${value.toStringAsFixed(0)}°C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }
                            )),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 50,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value < 0 || value >= city.days.length) {
                                  return Container();
                                }
                                DateTime date = DateTime.parse(city.days[value.toInt()].substring(0, 10));
                                String formattedDate = DateFormat('dd/MM').format(date);
                                return Transform.translate(
                                  offset: Offset(padding, 0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            )),
                          ),
                          lineTouchData: const LineTouchData(
                            touchSpotThreshold: 20,
                          ),
                          minY: _getMinTemperatureThreshold(),
                          maxY: _getMaxTemperatureThreshold(),
                          minX: 0,
                          maxX: 7,
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.white70,
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 5,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: Colors.white70,
                                strokeWidth: 1,
                                dashArray: [6, 6],
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return const FlLine(
                                color: Colors.white70,
                                strokeWidth: 1,
                                dashArray: [6, 6],
                              );
                            },
                          ),
                          clipData: const FlClipData.all(),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(8, (index) {
                                if (index == 7) {
                                  return FlSpot(
                                    index.toDouble() - 0.5,
                                    city.maxDailyTemperature[index - 1].toDouble(),
                                  );
                                }
                                return FlSpot(
                                  index.toDouble() + 0.5,
                                  city.maxDailyTemperature[index].toDouble(),
                                );
                              }),
                              color: red,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              preventCurveOverShooting: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: red,
                                  );
                                },
                              ),
                              shadow: const Shadow(
                                color: Colors.black,
                                blurRadius: 5,
                              ),
                            ),
                            LineChartBarData(
                              spots: List.generate(8, (index) {
                                if (index == 7) {
                                  return FlSpot(
                                    index.toDouble() - 0.5,
                                    city.minDailyTemperature[index - 1].toDouble(),
                                  );
                                }
                                return FlSpot(
                                  index.toDouble() + 0.5,
                                  city.minDailyTemperature[index].toDouble(),
                                );
                              }),
                              color: blue,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              preventCurveOverShooting: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: blue,
                                  );
                                },
                              ),
                              shadow: const Shadow(
                                color: Colors.black,
                                blurRadius: 5,
                              ),
                            ),
                          ],
                        ),
                        );
                      }
                    )
                  ),
                  const TemperatureLegend(),
                ]
              )
            )
          )
        ]
      )
    );
  }
}
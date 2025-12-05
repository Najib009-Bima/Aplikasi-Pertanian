import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrafikPage extends StatelessWidget {
  final List<Map<String, dynamic>> panenData;

  const GrafikPage({super.key, required this.panenData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Rekap Grafik",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFFF5FFF3),

      body: panenData.isEmpty
          ? const Center(
              child: Text(
                "Belum ada data panen",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),

                  // TITLES
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < panenData.length) {
                            return Text(
                              panenData[index]["nama"]
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),

                  // DATA
                  barGroups: List.generate(
                    panenData.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: double.tryParse(panenData[i]["jumlah"].toString()) ?? 0,
                          width: 22,
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pis_movil/services/service.dart';
import 'package:fl_chart/fl_chart.dart';

class SimulationScreen extends StatelessWidget {
  final Service service;
  final String title;

  SimulationScreen({super.key, required this.service, required this.title});

  Future<List<Map<String, dynamic>>> fetchSimulationData() async {
    final response = await service.simulationAir1();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 76, 121, 77),
        actions: [
          IconButton(
            icon: Image.asset(
                'assets/images/logo-unl.png'), // Ruta de la imagen del AppBar
            onPressed: () {
              // Acción al presionar la imagen en el AppBar
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSimulationData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final averageGlobal = data.fold<double>(0.0,
                    (sum, point) => sum + double.parse(point['average_data'])) /
                data.length;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: data.map((point) {
                              final x = DateTime.parse(point['date'])
                                  .millisecondsSinceEpoch
                                  .toDouble();
                              final y = double.parse(point['average_data']);
                              return FlSpot(x, y);
                            }).toList(),
                            isCurved: true,
                            barWidth: 4,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 3,
                                  color: Colors.green,
                                  strokeWidth: 1,
                                  strokeColor: Colors.green,
                                );
                              },
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString());
                              },
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                return Text('${date.day}/${date.month}');
                              },
                            ),
                          ),
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: averageGlobal,
                              color: Colors.red,
                              strokeWidth: 2,
                              dashArray: [5, 5],
                            ),
                          ],
                        ),
                        clipData: FlClipData.all(),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        minX: data.first['date'] != null
                            ? DateTime.parse(data.first['date'])
                                .millisecondsSinceEpoch
                                .toDouble()
                            : 0,
                        maxX: data.last['date'] != null
                            ? DateTime.parse(data.last['date'])
                                .millisecondsSinceEpoch
                                .toDouble()
                            : 0,
                        minY: data
                            .map((point) => double.parse(point['average_data']))
                            .reduce((a, b) => a < b ? a : b),
                        maxY: data
                            .map((point) => double.parse(point['average_data']))
                            .reduce((a, b) => a > b ? a : b),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Promedio de datos por fecha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4),
                        Text('Datos Promedio'),
                        SizedBox(width: 16),
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text('Promedio Global'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}

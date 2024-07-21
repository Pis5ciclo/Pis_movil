import 'package:flutter/material.dart';
import 'package:pis_movil/services/service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io'; // For SocketException

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
            // Check for network-related errors
            String errorMessage = 'An unexpected error occurred.';

            if (snapshot.error is SocketException) {
              errorMessage =
                  'El servidor no esta activado, por favor espere un momento';
            } else if (snapshot.error is HttpException) {
              errorMessage =
                  'Failed to fetch data. Please check your connection.';
            }

            return Center(child: Text(errorMessage));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            if (data.isEmpty) {
              return Center(child: Text('No data found'));
            }

            // Calcula el promedio global
            final averageGlobal = data.fold<double>(0.0, (sum, point) {
                  final avgValueStr = point['avg_value'];
                  final avgValue =
                      double.tryParse(avgValueStr?.toString() ?? '') ?? 0.0;
                  return sum + avgValue;
                }) /
                data.length;

            // Calcula minY y maxY manejando valores nulos
            final minY = data
                .map((point) =>
                    double.tryParse(point['avg_value']?.toString() ?? '') ??
                    0.0)
                .reduce((a, b) => a < b ? a : b);

            final maxY = data
                .map((point) =>
                    double.tryParse(point['avg_value']?.toString() ?? '') ??
                    0.0)
                .reduce((a, b) => a > b ? a : b);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 1000,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: data.map((point) {
                                  final dateStr = point['date'];
                                  final avgValueStr = point['avg_value'];
                                  final x = dateStr != null
                                      ? DateTime.parse(dateStr)
                                          .millisecondsSinceEpoch
                                          .toDouble()
                                      : 0.0;
                                  final y = double.tryParse(
                                          avgValueStr?.toString() ?? '') ??
                                      0.0;
                                  return FlSpot(x, y);
                                }).toList(),
                                isCurved: true,
                                barWidth: 4,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
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
                            minY: minY,
                            maxY: maxY,
                          ),
                        ),
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

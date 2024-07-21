import 'package:flutter/material.dart';
import 'package:pis_movil/services/service.dart';
import 'package:pis_movil/widgets/simulation_air1.dart';
import 'package:pis_movil/widgets/simulation_air2.dart';
import 'package:pis_movil/widgets/simulation_water.dart';
import 'dart:io'; // For SocketException

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final Service service = Service(baseUrl: "http://192.168.1.4:5000");

  Future<Map<String, dynamic>> fetchDataAir1() {
    return service.dataAir1();
  }

  Future<Map<String, dynamic>> fetchDataAir2() {
    // Asegúrate de tener una función similar en tu clase Service para obtener datos del otro sensor
    return service.dataAir2();
  }

  Future<Map<String, dynamic>> fetchDataWater() {
    // Asegúrate de tener una función similar en tu clase Service para obtener datos del otro sensor
    return service.dataWater();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Sensores'),
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
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: fetchDataAir1(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Check for network-related errors
                        String errorMessage =
                            'El servidor no esta activado, por favor espere un momento';
                        if (snapshot.error is SocketException) {
                          errorMessage =
                              'El servidor no esta activado, por favor espere un momento.';
                        }
                        return Text(errorMessage);
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SimulationScreen(
                                  service: service,
                                  title: 'Pronóstico',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight: 300), // Máximo alto del Container
                            child: Card(
                              color: Color.fromARGB(255, 44, 62, 94),
                              margin: EdgeInsets.only(left: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Sensor MQ135 (1)",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'assets/images/aire.png'),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${data['data']} CO2\n',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 245, 42, 42),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Fecha: ${data['date']}\n',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '  Hora: ${data['hour']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign
                                          .center, // Alineación central del texto rico
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text('No data found');
                      }
                    },
                  ),
                ),
                SizedBox(width: 8.0), // Espacio entre los cards
                Flexible(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: fetchDataAir2(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Check for network-related errors
                        String errorMessage =
                            'El servidor no esta activado, por favor espere un momento';
                        if (snapshot.error is SocketException) {
                          errorMessage =
                              'El servidor no esta activado, por favor espere un momento.';
                        }
                        return Text(errorMessage);
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SimulationScreenAir2(
                                  service: service,
                                  title: 'Pronóstico',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight: 300), // Máximo alto del Container
                            child: Card(
                              color: Color.fromARGB(255, 44, 62, 94),
                              margin: EdgeInsets.only(left: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Sensor MQ135 (2)",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'assets/images/aire.png'),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${data['data']} CO2\n',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 245, 42, 42),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Fecha: ${data['date']}\n',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '  Hora: ${data['hour']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign
                                          .center, // Alineación central del texto rico
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text('No data found');
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Flexible(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchDataWater(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Check for network-related errors
                    String errorMessage =
                        'El servidor no esta activado, por favor espere un momento';
                    if (snapshot.error is SocketException) {
                      errorMessage =
                          'El servidor no esta activado, por favor espere un momento.';
                    }
                    return Text(errorMessage);
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SimulationScreenWater(
                              service: service,
                              title: 'Pronóstico',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 270,
                        ),
                        child: Card(
                          color: Color.fromARGB(255, 44, 62, 94),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centra verticalmente
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Alinea a la izquierda
                              children: [
                                Center(
                                  // Centra el texto "Sensor TDS"
                                  child: Text(
                                    "Sensor TDS",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  // Centra el avatar
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('assets/images/agua.png'),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Center(
                                  // Centra el texto
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${data['data']} CO2\n',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 245, 42, 42),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Fecha: ${data['date']}\n',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '   Hora: ${data['hour']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text('No data found');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

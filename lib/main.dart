import 'package:flutter/material.dart';
import 'package:pis_movil/pages/page_principal.dart';
import 'package:pis_movil/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      home: DashboardScreen(),
    );
  }
}

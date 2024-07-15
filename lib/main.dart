import 'package:flutter/material.dart';
import 'package:googlemaps_test/pages/google_map_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromARGB(255, 97, 97, 97),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      routes: {
        '/landing': (context) => const GoogleMapPage(),
      },
      initialRoute: '/landing',
      debugShowCheckedModeBanner: false,
    );
  }
}

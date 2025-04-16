import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/form_screen.dart';
import 'screens/recording_screen.dart'; // Import the new screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/form': (context) => FormScreen(),
        '/recording': (context) => RecordingScreen(), // Register the new screen
      },
    );
  }
}

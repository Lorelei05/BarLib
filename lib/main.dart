import 'package:barmo/ui/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      )),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      title: 'QrScanner',
    );
  }
}

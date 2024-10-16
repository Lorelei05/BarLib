import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String mesa;
  final String piso;

  MenuScreen({required this.mesa, required this.piso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Número de mesa: $mesa',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Piso: $piso',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            Text(
              'Aquí se mostrará el menú.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Pantalla de Perfil de Usuario
class UserProfileScreen extends StatelessWidget {
  final String nombre;

  UserProfileScreen({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Perfil de Usuario"), backgroundColor: Colors.red),
      body: Center(
        child: Text(
          "Bienvenido, $nombre",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

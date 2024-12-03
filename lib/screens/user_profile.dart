import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String userName;

  const UserProfile({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              'Hola, $userName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text(
                'Editar perfil',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Acción para editar perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // Acción para cerrar sesión
                Navigator.pop(context); // Cerrar el Modal
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barmo/controllers/mongo_service.dart';
import 'package:crypto/crypto.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final MongoService _mongoService = MongoService();

  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() {
      isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String username = _usernameController.text.trim();
    String phone = _phoneController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        phone.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email)) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo electrónico no válido')),
      );
      return;
    }

    var digest = sha256.convert(utf8.encode(password));

    try {
      Map<String, dynamic> usuarioData = {
        'name': name,
        'lastName': lastName,
        'username': username,
        'email': email,
        'password': digest.toString(),
        'phone': phone,
        'fechaRegistro': DateTime.now().toIso8601String(),
      };

      await _mongoService.insertUsuario(usuarioData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado exitosamente')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro"), backgroundColor: Colors.red),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: "Apellidos"),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Correo electrónico"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Número de teléfono"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _registerUser,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}

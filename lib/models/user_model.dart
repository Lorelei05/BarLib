import 'package:mongo_dart/mongo_dart.dart';

class UsuarioModel {
  final ObjectId id;
  final String name;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String phone;
  final DateTime fechaRegistro;

  UsuarioModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['_id'] as ObjectId,
      name: json['name'],
      lastName: json['lastName'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }
}

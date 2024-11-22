import 'package:mongo_dart/mongo_dart.dart';

class MesaModel {
  final ObjectId id;
  final String nombre;
  final String hora;
  final int numero;
  final String piso;
  final int capacidad;
  final String estado;
  final String tipo;

  MesaModel({
    required this.id,
    required this.nombre,
    required this.hora,
    required this.numero,
    required this.piso,
    required this.capacidad,
    required this.estado,
    required this.tipo,
  });

  // Conversión de JSON a objeto MesaModel
  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(
      id: json['_id'] as ObjectId,
      nombre: json['nombre'] as String,
      hora: json['hora'] as String,
      numero: json['numero'] as int,
      piso: json['piso'] as String,
      capacidad: json['capacidad'] as int,
      estado: json['estado'] as String,
      tipo: json['tipo'] as String,
    );
  }

  // Conversión de objeto MesaModel a JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'hora': hora,
      'numero': numero,
      'piso': piso,
      'capacidad': capacidad,
      'estado': estado,
      'tipo': tipo,
    };
  }
}

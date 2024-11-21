import 'package:mongo_dart/mongo_dart.dart';

class PromocionModel {
  final ObjectId id;
  final String nombre;
  final String tipo;
  final String tipoDescuento;
  final double? porcentaje;
  final double? monto;
  final String? productoGratuitoId;
  final double? nuevoPrecio;
  final String? inicio;
  final String? finaliza;
  final bool activo;
  final ObjectId productoId;
  final String nombreProducto;

  PromocionModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.tipoDescuento,
    this.porcentaje,
    this.monto,
    this.productoGratuitoId,
    this.nuevoPrecio,
    this.inicio,
    this.finaliza,
    required this.activo,
    required this.productoId,
    required this.nombreProducto,
  });

  factory PromocionModel.fromJson(Map<String, dynamic> json) {
    return PromocionModel(
      id: json['_id'] as ObjectId,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      tipoDescuento: json['tipo_descuento'] as String,
      porcentaje: json['porcentaje']?.toDouble(),
      monto: json['monto']?.toDouble(),
      productoGratuitoId: json['producto_gratuito_id'],
      nuevoPrecio: json['nuevo_precio']?.toDouble(),
      inicio: json['inicio'],
      finaliza: json['finaliza'],
      activo: json['activo'] as bool,
      productoId: json['producto_id'] as ObjectId,
      nombreProducto: json['nombre_producto'] as String,
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  _PedidoScreenState createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  List<dynamic> _productos = [];

  // Función para cargar el JSON
  Future<void> cargarProductos() async {
    try {
      final String respuesta =
          await rootBundle.rootBundle.loadString('assets/productos.json');
      final datos = json.decode(respuesta);
      setState(() {
        _productos = datos['productos'];
      });
    } catch (e) {
      print("Error cargando productos: $e"); // Mensaje de error
    }
  }

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido'),
      ),
      body: _productos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.fastfood), // Icono temporal
                    title: Text(_productos[index]['nombre']),
                    subtitle: Text(
                        'Precio: \$${_productos[index]['precio'].toString()}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Aquí puedes implementar la lógica para añadir al carrito
                        print(
                            '${_productos[index]['nombre']} añadido al carrito');
                      },
                      child: Text('Añadir'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

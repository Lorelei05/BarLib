import 'package:flutter/material.dart';
import 'package:barmo/conexion.dart/mongo_service.dart';
import 'package:barmo/conexion.dart/producto_model.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late Future<List<ProductoModel>> _productos;

  @override
  void initState() {
    super.initState();
    _productos = MongoService().getProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
      ),
      body: FutureBuilder<List<ProductoModel>>(
        future: _productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay productos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var producto = snapshot.data![index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('${producto.precio.toStringAsFixed(2)} USD'),
                  onTap: () {
                    // Aquí podrías navegar a la pantalla de detalles del producto
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await MongoService().deleteProducto(producto.id);
                      setState(() {
                        _productos = MongoService().getProductos();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de agregar nuevo producto
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

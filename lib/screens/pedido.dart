import 'package:flutter/material.dart';
import 'package:barmo/controllers/mongo_service.dart';
import 'package:barmo/models/producto_model.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  _PedidoScreenState createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  late Future<List<ProductoModel>> _productosFuture;
  List<ProductoModel> _carrito = []; // Lista de productos en el carrito

  @override
  void initState() {
    super.initState();
    _productosFuture = MongoService().getProductos(forceRefresh: false);
  }

  // Función para calcular el total del carrito
  double get total {
    return _carrito.fold(0, (sum, item) => sum + item.precio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Haz tu pedido',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red.shade900,
      ),
      body: FutureBuilder<List<ProductoModel>>(
        future: _productosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error al cargar los productos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          final productos = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      elevation: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del producto
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(producto.imagen),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Detalles del producto
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    producto.nombre,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    producto.categoria,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${producto.precio.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Botón para añadir al carrito
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _carrito.add(producto); // Añadir al carrito
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${producto.nombre} añadido al carrito')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Mostrar el carrito y el total
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Carrito de compras',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Mostrar los productos en el carrito
                    if (_carrito.isNotEmpty)
                      Column(
                        children: _carrito.map((producto) {
                          return ListTile(
                            leading: Image.network(producto.imagen, width: 50),
                            title: Text(producto.nombre),
                            subtitle:
                                Text('\$${producto.precio.toStringAsFixed(2)}'),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                    // Mostrar el total
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    // Botón para realizar el pedido
                    ElevatedButton(
                      onPressed: () {
                        if (_carrito.isNotEmpty) {
                          // Realizar el pedido
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Pedido realizado con éxito')),
                          );
                          setState(() {
                            _carrito
                                .clear(); // Limpiar el carrito después de realizar el pedido
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Añade productos al carrito primero')),
                          );
                        }
                      },
                      child: const Text('Realizar Pedido'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:barmo/screens/login_screen.dart';
import 'package:barmo/screens/ofer_promo.dart';
import 'package:flutter/material.dart';
import 'package:barmo/screens/qr_scanner.dart';
import 'package:barmo/screens/pedido.dart';
import 'package:barmo/controllers/mongo_service.dart';
import 'package:barmo/widgets/category_selector.dart';
import 'package:barmo/widgets/product_list.dart';
import 'package:barmo/models/producto_model.dart';

class HomeScreen extends StatefulWidget {
  final String?
      userName; // Nombre del usuario (puede ser null si no inició sesión)

  const HomeScreen({super.key, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';
  String? scannedTable;
  String? scannedFloor;
  List<ProductoModel> _productos = [];
  List<ProductoModel> _productosFiltrados = [];
  String _query = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await MongoService().getProductos(forceRefresh: false);
      setState(() {
        _productos = productos;
        _productosFiltrados = productos;
      });
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  void _filtrarProductos(String query) {
    setState(() {
      _query = query.toLowerCase();
      _productosFiltrados = _productos.where((producto) {
        return producto.nombre.toLowerCase().contains(_query) ||
            producto.categoria.toLowerCase().contains(_query) ||
            selectedCategory == 'All' ||
            producto.categoria.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();
    });
  }

  void _filtrarPorCategoria(String category) {
    setState(() {
      selectedCategory = category;
      _query = "";
      _productosFiltrados = _productos.where((producto) {
        return category == 'All' ||
            producto.categoria.toLowerCase() == category.toLowerCase();
      }).toList();
    });
  }

  void updateScannedInfo(String table, String floor) {
    setState(() {
      scannedTable = table;
      scannedFloor = floor;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 21, 7),
        elevation: 0,
        title: widget.userName != null
            ? Row(
                children: [
                  Text(
                    '${widget.userName}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              )
            : TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  'Regístrate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
        actions: [
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/icons/icons8-mesa-de-restaurante-64.png'),
              size: 40,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              if (scannedTable != null && scannedFloor != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Información de la Mesa"),
                    content: Text("Mesa: $scannedTable\nPiso: $scannedFloor"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cerrar"),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No se ha escaneado ninguna mesa."),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 218, 21, 7), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _filtrarProductos,
                  ),
                ),
                CategorySelector(
                  onCategorySelected: _filtrarPorCategoria,
                ),
                Expanded(
                  child: _productosFiltrados.isEmpty
                      ? const Center(
                          child: Text('No se encontraron productos.'))
                      : ListView.builder(
                          itemCount: _productosFiltrados.length,
                          itemBuilder: (context, index) {
                            final producto = _productosFiltrados[index];
                            return ProductCard(
                              title: producto.nombre,
                              price: producto.precio.toString(),
                              imagePath: producto.imagen,
                            );
                          },
                        ),
                ),
              ],
            ),
            const PromocionesScreen(),
            const Center(child: Text('Pantalla de QR')),
            const PedidoScreen(),
            LoginScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomAppBar(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.home), text: 'Inicio'),
                Tab(icon: Icon(Icons.local_offer), text: 'Ofertas'),
                Tab(icon: Icon(Icons.qr_code_scanner), text: 'QR'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Pedido'),
                Tab(icon: Icon(Icons.person), text: 'Registro'),
              ],
              indicatorColor: Colors.redAccent,
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QrScanner(onCodeScanned: updateScannedInfo),
                  ),
                );
                if (result != null) {
                  updateScannedInfo(result['table'], result['floor']);
                }
              },
              child: const Icon(Icons.qr_code_scanner,
                  size: 40, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

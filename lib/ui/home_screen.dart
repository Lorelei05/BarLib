import 'package:flutter/material.dart';
import 'package:barmo/scanner/qr_scanner.dart';
import 'package:barmo/ui/pedido.dart';
import 'package:barmo/conexion.dart/mongo_service.dart';
import 'product_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';
  String? scannedTable;
  String? scannedFloor;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    super.initState();
  }

  void _filterCategory(String category) {
    setState(() {
      selectedCategory = category;
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
          backgroundColor: Colors.red.shade900,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/perfil.jpg'),
                radius: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Lorelei Leon',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: ImageIcon(
                AssetImage('icons/icons8-mesa-de-restaurante-64.png'),
                size: 40,
                color: Colors.black,
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
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder(
              future: MongoService().connect(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al conectar'));
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    CategorySection(onCategorySelected: _filterCategory),
                    ProductList(selectedCategory: selectedCategory),
                  ],
                );
              },
            ),
            Center(child: Text('Pantalla de Buscar')),
            Center(child: Text('Pantalla de QR')),
            Center(child: Text('Pantalla de Ofertas')),
            PedidoScreen(),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            BottomAppBar(
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.home), text: 'Inicio'),
                  Tab(icon: Icon(Icons.search), text: 'Buscar'),
                  SizedBox(width: 60),
                  Tab(icon: Icon(Icons.local_offer), text: 'Ofertas'),
                  Tab(icon: Icon(Icons.shopping_cart), text: 'Pedido'),
                ],
                indicatorColor: Colors.red.shade900,
                labelColor: Colors.red.shade900,
                unselectedLabelColor: Colors.grey,
              ),
            ),
            Positioned(
              bottom: 25,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: () async {
                  // Llamada al escáner QR
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScanner(
                        onCodeScanned: (table, floor) {
                          updateScannedInfo(
                              table, floor); // Actualiza la info escaneada
                        },
                      ),
                    ),
                  );
                  // Aquí puedes procesar el resultado escaneado si es necesario
                  if (result != null) {
                    setState(() {
                      scannedTable = result['table'];
                      scannedFloor = result['floor'];
                    });
                  }
                },
                child:
                    Icon(Icons.qr_code_scanner, size: 40, color: Colors.black),
              ),
            ),
          ],
        ));
  }
}

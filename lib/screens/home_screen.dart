// home_screen.dart
import 'package:app_bar_lib/screens/scan_screen.dart'; // Asegúrate de importar ScanScreen
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTableSelection);
    super.initState();
  }

  _handleTableSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
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
              // Acciones al presionar el icono de la mesa
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade900, Colors.black],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            _buildCategorySection(),
            _buildProductList(),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomAppBar(
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.home), text: 'Inicio'),
                Tab(icon: Icon(Icons.search), text: 'Buscar'),
                SizedBox(width: 60), // Espacio reservado para el icono QR
                Tab(icon: Icon(Icons.local_offer), text: 'Ofertas'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Pedido'),
              ],
              indicatorColor: Colors.red.shade900,
              labelColor: Colors.red.shade900,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Positioned(
            bottom: 25, // Para que el QR esté por encima de la barra inferior
            left: MediaQuery.of(context).size.width / 2 -
                30, // Centra el icono QR
            child: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () {
                // Navega a la pantalla de escaneo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen()),
                );
              },
              child: Icon(Icons.qr_code_scanner, size: 40, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCategoryItem('Drinks', Icons.local_drink, Colors.pink),
          _buildCategoryItem('Cerveza', Icons.local_bar, Colors.amber),
          _buildCategoryItem('Snacks', Icons.fastfood, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildProductCard('Bebidas', '22.85', 'images/bebidas.jpg'),
          _buildProductCard('Alitas', '50.65', 'images/alitas.jpg'),
          _buildProductCard('Snacks', '30.55', 'images/snacks.jpg'),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String price, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:barmo/controllers/mongo_service.dart';
import 'package:flutter/material.dart';
import '../models/promocion_model.dart';

class PromocionesScreen extends StatefulWidget {
  const PromocionesScreen({Key? key}) : super(key: key);

  @override
  State<PromocionesScreen> createState() => _PromocionesScreenState();
}

class _PromocionesScreenState extends State<PromocionesScreen> {
  late Future<List<PromocionModel>> _futurePromociones;

  @override
  void initState() {
    super.initState();
    _futurePromociones = MongoService().getPromociones(); // Usa MongoService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Promociones"),
      ),
      body: FutureBuilder<List<PromocionModel>>(
        future: _futurePromociones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar promociones."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay promociones disponibles."));
          } else {
            final promociones = snapshot.data!;
            return ListView.builder(
              itemCount: promociones.length,
              itemBuilder: (context, index) {
                final promo = promociones[index];
                return Card(
                  child: ListTile(
                    title: Text(promo.nombre),
                    subtitle: Text(
                        "Tipo: ${promo.tipo} | Producto: ${promo.nombreProducto}"),
                    trailing: Text(promo.tipoDescuento == 'porcentaje'
                        ? '${promo.porcentaje}%'
                        : '\$${promo.monto}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

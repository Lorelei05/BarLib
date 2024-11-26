// import 'package:flutter/material.dart';
// import 'package:barmo/controllers/mongo_service.dart';
// import 'package:barmo/models/mesa_model.dart';

// class MesaScreen extends StatefulWidget {
//   @override
//   _MesaScreenState createState() => _MesaScreenState();
// }

// class _MesaScreenState extends State<MesaScreen> {
//   List<MesaModel> mesas = [];
//   MesaModel? selectedMesa;
//   TextEditingController _mesaController = TextEditingController();
//   TextEditingController _pisoController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchMesas();
//   }

//   Future<void> fetchMesas() async {
//     try {
//       final mongoService = MongoService();
//       await mongoService.connect(); // Asegúrate de estar conectado
//       final fetchedMesas = await mongoService.getMesas();
//       setState(() {
//         mesas = fetchedMesas;
//       });
//     } catch (e) {
//       print("Error al obtener las mesas: $e");
//     }
//   }

//   Future<void> buscarMesaPorNumeroYPiso() async {
//     int numeroMesa = int.tryParse(_mesaController.text) ?? 0;
//     int numeroPiso = int.tryParse(_pisoController.text) ?? 0;

//     try {
//       final mongoService = MongoService();
//       await mongoService.connect();
//       final mesa =
//           await mongoService.getMesaByNumeroYPiso(numeroMesa, numeroPiso);

//       if (mesa != null) {
//         showMesaDetails(mesa);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("No se encontró ninguna mesa.")),
//         );
//       }
//     } catch (e) {
//       print("Error al buscar la mesa: $e");
//     }
//   }

//   void showMesaDetails(MesaModel mesa) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Información de la Mesa"),
//         content: Text(
//           "Nombre: ${mesa.nombre}\n"
//           "Hora: ${mesa.hora}\n"
//           "Número: ${mesa.numero}\n"
//           "Piso: ${mesa.piso}\n"
//           "Capacidad: ${mesa.capacidad}\n"
//           "Estado: ${mesa.estado}\n"
//           "Tipo: ${mesa.tipo}",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cerrar"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Mesas"),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _mesaController,
//               decoration: InputDecoration(
//                 labelText: 'Número de Mesa',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _pisoController,
//               decoration: InputDecoration(
//                 labelText: 'Piso',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: buscarMesaPorNumeroYPiso,
//             child: Text('Buscar Mesa'),
//           ),
//           Expanded(
//             child: mesas.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: mesas.length,
//                     itemBuilder: (context, index) {
//                       final mesa = mesas[index];
//                       return ListTile(
//                         title: Text("Mesa ${mesa.numero} - Piso ${mesa.piso}"),
//                         subtitle: Text(
//                             "Capacidad: ${mesa.capacidad} - Estado: ${mesa.estado}"),
//                         trailing: Icon(Icons.info_outline),
//                         onTap: () => showMesaDetails(mesa),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (selectedMesa != null) {
//             showMesaDetails(selectedMesa!);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("No se ha seleccionado ninguna mesa.")),
//             );
//           }
//         },
//         child: Icon(Icons.table_chart),
//       ),
//     );
//   }
// }

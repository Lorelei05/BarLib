import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/producto_model.dart';
import '../models/promocion_model.dart';
// import '../models/mesa_model.dart';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  late mongo.Db _db;

  List<ProductoModel> _cachedProductos = [];
  List<ProductoModel> allProductos = [];
  List<PromocionModel> _cachedPromociones = [];
  // List<MesaModel> _cachedMesas = [];

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
    _db = await mongo.Db.create(
        'mongodb+srv://vasanchezb:yvBEqytDiZplhLWo@barlib.hfeoz.mongodb.net/BarLib?retryWrites=true&w=majority&appName=BarLib');
    await _db.open();
  }

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError(
          'Base de datos no inicializada, llama a connect() primero');
    }
    return _db;
  }

  // Funciones de Productos
  Future<List<ProductoModel>> getProductos({bool forceRefresh = false}) async {
    if (_cachedProductos.isNotEmpty && !forceRefresh) {
      return _cachedProductos;
    }
    var collection = db.collection('home_producto');
    var productos = await collection.find().toList();
    print(
        "Productos obtenidos: $productos"); // Agrega este print para depuración.
    _cachedProductos =
        productos.map((prod) => ProductoModel.fromJson(prod)).toList();
    return _cachedProductos;
  }

  Future<void> insertProducto(ProductoModel producto) async {
    var collection = db.collection('home_producto');
    await collection.insertOne(producto.toJson());
    _cachedProductos.clear();
  }

  Future<void> updateProducto(ProductoModel producto) async {
    var collection = db.collection('home_producto');
    await collection.updateOne(
      mongo.where.eq('_id', producto.id),
      mongo.modify
          .set('nombre', producto.nombre)
          .set('precio', producto.precio)
          .set('categoria', producto.categoria)
          .set('imagen', producto.imagen)
          .set('cantidad', producto.cantidad)
          .set('unidad', producto.unidad),
    );
    _cachedProductos.clear();
  }

  Future<void> deleteProducto(mongo.ObjectId id) async {
    var collection = db.collection('home_producto');
    await collection.remove(mongo.where.eq('_id', id));
    _cachedProductos.clear();
  }

  // Funciones de Promociones
  Future<List<PromocionModel>> getPromociones(
      {bool forceRefresh = false}) async {
    if (_cachedPromociones.isNotEmpty && !forceRefresh) {
      return _cachedPromociones;
    }
    var collection = db.collection('home_promocion');
    var promociones =
        await collection.find(mongo.where.eq('activo', true)).toList();
    _cachedPromociones =
        promociones.map((promo) => PromocionModel.fromJson(promo)).toList();
    return _cachedPromociones;
  }

  // Función para insertar un usuario en la colección 'usuarios'
  Future<void> insertUsuario(Map<String, dynamic> usuarioData) async {
    var collection = db.collection('user_register');
    await collection.insertOne(usuarioData);
  }

  // Obtener usuario por correo
  Future<Map<String, dynamic>?> getUsuario(String email) async {
    var collection = db.collection('user_register');
    return await collection.findOne(mongo.where.eq('email', email));
  }

  Future<List<Map<String, dynamic>>> fetchUsuarios() async {
    var collection = db.collection('user_register');
    var usuarios = await collection.find().toList();
    print('Usuarios en la base de datos: $usuarios');
    return usuarios;
  }
}

  // Funciones de Mesas
  // Future<List<MesaModel>> getMesas({bool forceRefresh = false}) async {
  //   if (_cachedMesas.isNotEmpty && !forceRefresh) {
  //     return _cachedMesas;
  //   }
  //   var collection = db.collection('Mesas_mesa');
  //   var mesas = await collection.find().toList();
  //   _cachedMesas = mesas.map((mesa) => MesaModel.fromJson(mesa)).toList();
  //   return _cachedMesas;
  // }

  // Future<MesaModel?> getMesaByNumeroYPiso(int numero, int piso) async {
  //   var collection = db.collection('Mesas_mesa');
  //   var mesaData = await collection
  //       .findOne(mongo.where.eq('numero', numero).eq('piso', piso));
  //   if (mesaData != null) {
  //     return MesaModel.fromJson(mesaData);
  //   }
  //   return null;
  // }

  // Future<void> updateMesa(MesaModel mesa) async {
  //   var collection = db.collection('Mesas_mesa');
  //   await collection.updateOne(
  //     mongo.where.eq('_id', mesa.id),
  //     mongo.modify
  //         .set('nombre', mesa.nombre)
  //         .set('hora', mesa.hora)
  //         .set('numero', mesa.numero)
  //         .set('piso', mesa.piso)
  //         .set('capacidad', mesa.capacidad)
  //         .set('estado', mesa.estado)
  //         .set('tipo', mesa.tipo),
  //   );
  //   _cachedMesas.clear();
  // }

  // Future<void> deleteMesa(mongo.ObjectId id) async {
  //   var collection = db.collection('Mesas_mesa');
  //   await collection.remove(mongo.where.eq('_id', id));
  //   _cachedMesas.clear();
  // }

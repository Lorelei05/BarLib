import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'producto_model.dart';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  late mongo.Db _db;

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

  Future<List<ProductoModel>> getProductos() async {
    var collection = db.collection('home_producto');
    var productos = await collection.find().toList();
    return productos.map((prod) => ProductoModel.fromJson(prod)).toList();
  }

  Future<void> insertProducto(ProductoModel producto) async {
    var collection = db.collection('home_producto');
    await collection.insertOne(producto.toJson());
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
  }

  Future<void> deleteProducto(mongo.ObjectId id) async {
    var collection = db.collection('home_producto');
    await collection.remove(mongo.where.eq('_id', id));
  }
}

//'mongodb+srv://vasanchezb:yvBEqytDiZplhLWo@barlib.hfeoz.mongodb.net/BarLib?retryWrites=true&w=majority&appName=BarLib'

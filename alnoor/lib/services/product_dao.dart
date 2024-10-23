import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import 'database_helper.dart';

class ProductDao {
  final dbHelper = DatabaseHelper.instance;

  // Insert or update a product
  Future<void> insertOrUpdateProducts(List<Product> products) async {
    Database db = await dbHelper.database;
    Batch batch = db.batch();

    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('Inserted/Updated ${products.length} products');
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Clear all products (if needed)
  Future<void> clearProducts() async {
    Database db = await dbHelper.database;
    await db.delete('products');
    print('Cleared products table');
  }
}

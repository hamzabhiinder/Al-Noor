// services/category_dao.dart

import 'package:sqflite/sqflite.dart';
import '../models/category.dart';
import 'database_helper.dart';

class CategoryDao {
  final dbHelper = DatabaseHelper.instance;

  // Insert or update categories
  Future<void> insertOrUpdateCategories(List<Category> categories) async {
    Database db = await dbHelper.database;
    Batch batch = db.batch();

    for (var category in categories) {
      batch.insert(
        'categories',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('Inserted/Updated ${categories.length} categories');
  }

  // Get all categories
  Future<List<Category>> getCategories() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Clear all categories (if needed)
  Future<void> clearCategories() async {
    Database db = await dbHelper.database;
    await db.delete('categories');
    print('Cleared categories table');
  }
}

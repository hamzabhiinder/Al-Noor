import 'package:sqflite/sqflite.dart';
import '../models/subcategory.dart';
import 'database_helper.dart';

class SubcategoryDao {
  final dbHelper = DatabaseHelper.instance;

  // Insert or update subcategories
  Future<void> insertOrUpdateSubcategories(List<Subcategory> subcategories) async {
    Database db = await dbHelper.database;
    Batch batch = db.batch();

    for (var subcategory in subcategories) {
      batch.insert(
        'subcategories',
        subcategory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('Inserted/Updated ${subcategories.length} subcategories');
  }

  // Get all subcategories
  Future<List<Subcategory>> getSubcategories() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('subcategories');
    return List.generate(maps.length, (i) {
      return Subcategory.fromMap(maps[i]);
    });
  }

  // Clear all subcategories (if needed)
  Future<void> clearSubcategories() async {
    Database db = await dbHelper.database;
    await db.delete('subcategories');
    print('Cleared subcategories table');
  }
}

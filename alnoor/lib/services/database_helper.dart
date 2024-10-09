// services/database_helper.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Database details
  static final _databaseName = "AppDatabase.db";
  static final _databaseVersion = 3; // Incremented version

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print('Initializing database at $path');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Handle database upgrades
    );
  }

  // Create tables
  Future _onCreate(Database db, int version) async {
    print('Creating database tables');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        city TEXT NOT NULL,
        password TEXT NOT NULL, -- Hashed password
        plain_password TEXT, -- Plain password for syncing
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create products table
    await db.execute('''
      CREATE TABLE products (
        product_id TEXT PRIMARY KEY,
        thumbnail_image TEXT,
        product_name TEXT,
        product_slug TEXT,
        product_image TEXT,
        product_image2 TEXT,
        product_image3 TEXT,
        product_image4 TEXT,
        product_type TEXT,
        product_short_desc TEXT,
        product_reg_price TEXT,
        product_status TEXT,
        product_created_at TEXT,
        product_updated_at TEXT
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT,
        slug TEXT,
        image TEXT,
        status TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Create subcategories table
    await db.execute('''
      CREATE TABLE subcategories (
        sub_category_id TEXT PRIMARY KEY,
        category_id TEXT,
        sub_category_name TEXT,
        sub_category_slug TEXT,
        sub_category_status TEXT,
        sub_category_created_at TEXT,
        sub_category_updated_at TEXT
      )
    ''');
  }

  // Handle database upgrade
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    if (oldVersion < 2) {
      // Add 'plain_password' column to 'users' table
      await db.execute("ALTER TABLE users ADD COLUMN plain_password TEXT");
      print('Added plain_password column to users table');
    }
    if (oldVersion < 3) {
      // Create new tables for products, categories, and subcategories
      await _onCreate(db, newVersion);
    }
  }
}

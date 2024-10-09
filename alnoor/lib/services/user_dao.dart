// services/user_dao.dart

import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../services/database_helper.dart';

class UserDao {
  final dbHelper = DatabaseHelper.instance;

  // Insert or update a user
  Future<int> insertOrUpdateUser(User user) async {
    print('Inserting or updating user: ${user.email}');
    Database db = await dbHelper.database;

    // Check if user already exists
    User? existingUser = await getUserByEmail(user.email);

    if (existingUser != null) {
      // Update user
      user.id = existingUser.id; // Ensure the ID is set
      int count = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      print('Updated user: ${user.email}, Rows affected: $count');
      return count;
    } else {
      // Insert new user
      int id = await db.insert('users', user.toMap());
      print('Inserted new user: ${user.email}, ID: $id');
      return id;
    }
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    print('Fetching user by email: $email');
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      print('User found: $email');
      return User.fromMap(maps.first);
    }
    print('User not found: $email');
    return null;
  }

  // Get unsynced users
  Future<List<User>> getUnsyncedUsers() async {
    print('Fetching unsynced users');
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    print('Unsynced users count: ${maps.length}');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }
}

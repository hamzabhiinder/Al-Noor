// repositories/register_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';

import '../models/user.dart';
import '../services/user_dao.dart';

class RegisterRepository {
  final String _baseUrl = 'https://alnoormdf.com/alnoor/signup';
  final UserDao userDao = UserDao();

  // Check internet connectivity
  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;
    print('Internet connectivity: $connected');
    return connected;
  }

  // Hash the password using SHA-256
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    print('Hashed password');
    return digest.toString();
  }

  // Register user
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String city,
    String password,
    String confirmPassword,
  ) async {
    print('Registering user: $email');
    bool isConnected = await _isConnected();

    // Hash the password
    String hashedPassword = _hashPassword(password);

    // Create User instance
    User user = User(
      name: name,
      email: email,
      phone: phone,
      city: city,
      password: hashedPassword, // Store hashed password
      plainPassword: isConnected ? null : password, // Store plain password if offline
      isSynced: isConnected,
    );

    // Save locally
    await userDao.insertOrUpdateUser(user);

    if (isConnected) {
      // Online registration
      try {
        print('Attempting online registration for $email');
        final response = await http.post(
          Uri.parse(_baseUrl),
          body: {
            'name': name,
            'email': email,
            'phone': phone,
            'city': city,
            'password': password,
            'confirm_password': confirmPassword,
          },
        );
        print('Registration response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          // Update as synced
          user.isSynced = true;
          user.plainPassword = null; // Remove plain password after syncing
          await userDao.insertOrUpdateUser(user);
          print('Registration successful for $email');
          return json.decode(response.body);
        } else {
          final error = json.decode(response.body)['error'] ?? 'Failed to register';
          print('Registration failed for $email: $error');
          throw Exception(error);
        }
      } catch (error) {
        print('Registration exception for $email: $error');
        throw Exception('Registration failed: $error');
      }
    } else {
      // Offline registration
      print('Offline registration saved for $email');
      return {
        'status': 'pending',
        'message': 'Registration saved locally. Will sync when online.'
      };
    }
  }

  // Sync unsynced users
  Future<void> syncUsers() async {
    print('Attempting to sync unsynced users');
    bool isConnected = await _isConnected();
    if (isConnected) {
      List<User> unsyncedUsers = await userDao.getUnsyncedUsers();
      for (var user in unsyncedUsers) {
        try {
          print('Syncing user: ${user.email}');
          final response = await http.post(
            Uri.parse(_baseUrl),
            body: {
              'name': user.name,
              'email': user.email,
              'phone': user.phone,
              'city': user.city,
              'password': user.plainPassword ?? '',
              'confirm_password': user.plainPassword ?? '',
            },
          );
          print('Sync response status for ${user.email}: ${response.statusCode}');

          if (response.statusCode == 200) {
            // Update as synced
            user.isSynced = true;
            user.plainPassword = null; // Remove plain password after syncing
            await userDao.insertOrUpdateUser(user);
            print('User synced successfully: ${user.email}');
          } else {
            print('Failed to sync user: ${user.email}, Response: ${response.body}');
          }
        } catch (error) {
          print('Error syncing user: ${user.email}, Error: $error');
          break;
        }
      }
    } else {
      print('No internet connection. Cannot sync users.');
    }
  }
}

// repositories/login_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:io'; // Import for SocketException

import '../models/user.dart';
import '../services/user_dao.dart';
import '../utils/globals.dart' as globals;

class LoginRepository {
  final String _baseUrl = 'https://alnoormdf.com/alnoor/login';
  final UserDao userDao = UserDao();

  // Check actual internet connectivity
  Future<bool> _isConnected() async {
    bool isConnected = false;
    try {
      // Try to make a request to a reliable server
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    print('Internet connectivity: $isConnected');
    return isConnected;
  }

  // Hash the password using SHA-256
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    print('Hashed password');
    return digest.toString();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('Logging in user: $email');
    bool isConnected = await _isConnected();

    String hashedPassword = _hashPassword(password);

    if (isConnected) {
      // Online login
      print('Attempting online login for $email');
      try {
        final response = await http.post(
          Uri.parse(_baseUrl),
          body: {
            'email': email,
            'password': password,
          },
        );
        print('Login response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);

          // Store the name in the global variable
          globals.userName = responseData['user']['name'];
          globals.token = responseData['token'];
          globals.freshLogin = 'true';

          // Update local database with the latest user data
          User user = User(
            name: responseData['user']['name'],
            email: responseData['user']['email'],
            phone: responseData['user']['phone'],
            city: responseData['user']['city'],
            password: hashedPassword, // Store hashed password
            isSynced: true,
          );
          await userDao.insertOrUpdateUser(user);
          print('Online login successful for $email');
          return responseData;
        } else {
          print('Online login failed for $email');
          throw Exception('Failed to login');
        }
      } catch (error) {
        print('Error during online login for $email: $error');
        throw Exception('Failed to login: $error');
      }
    } else {
      // Offline login
      print('Attempting offline login for $email');
      User? user = await userDao.getUserByEmail(email);

      if (user != null) {
        // Compare hashed passwords
        if (user.password == hashedPassword) {
          // Authentication successful
          globals.userName = user.name;
          globals.freshLogin = 'true';
          print('Offline login successful for $email');
          return {
            'status': 'success',
            'message': 'Logged in offline',
            'user': {
              'name': user.name,
              'email': user.email,
              'phone': user.phone,
              'city': user.city,
            },
          };
        } else {
          print('Invalid credentials for offline login: $email');
          throw Exception('Invalid credentials');
        }
      } else {
        print('User not found for offline login: $email');
        throw Exception(
            'User not found. Please connect to the internet and login once.');
      }
    }
  }
}

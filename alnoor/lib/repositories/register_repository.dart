import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterRepository {
  final String _baseUrl = 'https://alnoormdf.com/alnoor/signup';

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
                print('API is hit');

        return json.decode(response.body);
      } else {
        // Handle specific error codes or extract error message from response
        final error = json.decode(response.body)['error'] ?? 'Failed to register';
        throw Exception(error);
      }
    } catch (error) {
      // Handle network issues or unexpected errors
      throw Exception('Registration failed: $error');
    }
  }
}

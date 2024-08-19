import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterRepository {
  final String _baseUrl = 'https://alnoormdf.com/alnoor/signup';

  Future<Map<String, dynamic>> register(String name, String email, String phone, String city, String password, String confirm_password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'city' : city,          
          'password': password,
          'confirm_password': confirm_password
        },
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Handle specific error codes or extract error message from response
        final error = json.decode(response.body)['error'] ?? 'Failed to register';
        throw Exception(error);
      }
    } catch (error) {
      // Handle network issues or unexpected errors
      print('Registration failed: $error');
      throw Exception('Registration failed: $error');
    }
  }
}

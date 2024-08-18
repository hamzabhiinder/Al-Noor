import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRepository {
  final String _baseUrl = 'https://alnoormdf.com/alnoor/login';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }
}

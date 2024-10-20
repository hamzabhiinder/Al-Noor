import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alnoor/utils/globals.dart' as globals;

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
      Map<String, dynamic> responseData = json.decode(response.body);

      // Store the name in the global variable
      globals.userName = responseData['user']['name'];
      globals.token = responseData['token'];
      globals.freshLogin = 'true';
      print(responseData['token']);

      return responseData;
    } else {
      throw Exception('Failed to login');
    }
  }
}

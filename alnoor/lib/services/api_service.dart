import 'package:http/http.dart' as http;

class ApiService {
  Future<bool> registerUser(String name, String email, String phone, String city, String password) async {
    // Replace with your API endpoint
    const String apiUrl = "https://example.com/api/register";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'city': city,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle error
      return false;
    }
  }

 Future<bool> loginUser(String email, String password) async {
    const String apiUrl = "https://example.com/api/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle error
      return false;
    }
  }
}
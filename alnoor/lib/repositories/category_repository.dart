import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alnoor/models/category.dart';

class CategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/categories';

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> data = map["data"];
        List<Category> categories =
            data.map((item) => Category.fromJson(item)).toList();
        return categories.take(8).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}

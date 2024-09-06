import 'dart:convert';
import 'package:alnoor/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/all-categories';

  Future<List> fetchSubcategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> data = map["data"];
        // Extract subcategory arrays from the original data
        List subcategories = data
            .where((item) => item is List)
            .map((subcategoryArray) => subcategoryArray
                .map((item) => Subcategory.fromJson(item))
                .toList())
            .toList();

        return subcategories.take(8).toList(); // Limit to the first 8 arrays
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}

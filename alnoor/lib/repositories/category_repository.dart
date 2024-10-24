import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alnoor/models/category.dart';
import 'package:hive/hive.dart';

class CategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/categories';

  Future<List<Category>> fetchCategories() async {
    var box = Hive.box('categoriesBox');
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> data = map["data"];
        List<Category> categories =
            data.map((item) => Category.fromJson(item)).toList();

        if (categories.length >= 8) {
          final temp = categories[1];
          categories[1] = categories[7];
          categories[7] = temp;
        }

        await box.put('categories', data); // Save fetched data to Hive

        return categories.take(8).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      if (box.containsKey('categories')) {
        final cachedCategories = box.get('categories') as List<dynamic>;
        return cachedCategories
            .map((item) => Category.fromJson(item))
            .toList()
            .take(8)
            .toList();
      } else {
        throw Exception('Failed to fetch categories: $e');
      }
    }
  }
}

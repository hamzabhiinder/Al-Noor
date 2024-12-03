import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alnoor/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/categories';

  Future<List<Category>> fetchCategories() async {
    List<Category> localCategory = await _fetchCategoriesFromLocal();
    if (localCategory.isNotEmpty) {
      return localCategory.take(8).toList();
    }

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
        _saveCategoriesToLocal(categories);

        return categories.take(8).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      //return await _fetchCategoriesFromLocal();
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<void> _saveCategoriesToLocal(List<Category> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('categories');
    List<String> jsonCategories =
        categories.map((category) => jsonEncode(category.toJson())).toList();
    prefs.setStringList('categories', jsonCategories);
  }

  // Fetch categories from local storage
  Future<List<Category>> _fetchCategoriesFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonCategories = prefs.getStringList('categories');

    if (jsonCategories != null) {
      List<Category> categories = jsonCategories
          .map((jsonCategory) => Category.fromJson(jsonDecode(jsonCategory)))
          .toList();
      return categories;
    } else {
      return [];
      throw Exception('No categories found in local storage');
    }
  }
}

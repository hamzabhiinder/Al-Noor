// repositories/category_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alnoor/models/category.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/category_dao.dart';

class CategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/categories';
  final CategoryDao categoryDao = CategoryDao();

  // Check internet connectivity
  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Category>> fetchCategories() async {
    bool isConnected = await _isConnected();
    print('Connectivity status: $isConnected');

    if (isConnected) {
      // Online - fetch from API
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

          // Store categories locally
          await categoryDao.insertOrUpdateCategories(categories);

          return categories.take(8).toList();
        } else {
          throw Exception('Failed to load categories');
        }
      } catch (e) {
        print('Error fetching categories online: $e');
        // Optionally, fall back to local data
        return await _fetchCategoriesFromLocal();
      }
    } else {
      // Offline - fetch from local database
      return await _fetchCategoriesFromLocal();
    }
  }

  Future<List<Category>> _fetchCategoriesFromLocal() async {
    print('Fetching categories from local database');
    List<Category> categories = await categoryDao.getCategories();

    if (categories.length >= 8) {
      final temp = categories[1];
      categories[1] = categories[7];
      categories[7] = temp;
    }

    return categories.take(8).toList();
  }
}

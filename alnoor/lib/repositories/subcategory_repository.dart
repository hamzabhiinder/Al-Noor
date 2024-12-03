import 'dart:convert';
import 'package:alnoor/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/all-categories';

  Future<List> fetchSubcategories() async {
    List cachedData = await _fetchSubcategoriesFromLocal();
    if (cachedData.isNotEmpty) {
      return cachedData;
    }
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> data = map["data"];
        List subcategories = data
            .where((item) => item is List)
            .map((subcategoryArray) => subcategoryArray
                .map((item) => Subcategory.fromJson(item))
                .toList())
            .toList();
        List limitedSubcategories = subcategories.take(8).toList();

        if (limitedSubcategories.length >= 8) {
          var temp = limitedSubcategories[1];
          limitedSubcategories[1] = limitedSubcategories[7];
          limitedSubcategories[7] = temp;
        }
        await _saveSubcategoriesToLocal(response.body);
        return [[], [], [], [], [], [], [], limitedSubcategories[7]];
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<void> _saveSubcategoriesToLocal(String subcategories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('subcategories', subcategories);
  }

  Future<List<dynamic>> _fetchSubcategoriesFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the string from SharedPreferences
    String? stringList = prefs.getString('subcategories');

    // If no data is found in SharedPreferences, return an empty list
    if (stringList == null || stringList.isEmpty) {
      return [];
    }

    try {
      Map<String, dynamic> map = json.decode(stringList);

      List<dynamic> data = map["data"];

      List subcategories = data
          .where((item) => item is List)
          .map((subcategoryArray) => subcategoryArray
              .map((item) => Subcategory.fromJson(item))
              .toList())
          .toList();

      List limitedSubcategories = subcategories.take(8).toList();

      if (limitedSubcategories.length >= 8) {
        var temp = limitedSubcategories[1];
        limitedSubcategories[1] = limitedSubcategories[7];
        limitedSubcategories[7] = temp;
      }

      return [[], [], [], [], [], [], [], limitedSubcategories[7]];
    } catch (e) {
      print('Error fetching subcategories: $e');
      return [];
    }
  }
}

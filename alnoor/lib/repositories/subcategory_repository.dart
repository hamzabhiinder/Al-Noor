import 'dart:convert';
import 'package:alnoor/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class SubcategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/all-categories';

  Future<List> fetchSubcategories() async {
    var box = Hive.box('subcategoriesBox');
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

        await box.put('subcategories', data); // Save fetched data to Hive

        return [[], [], [], [], [], [], [], limitedSubcategories[7]];
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      if (box.containsKey('subcategories')) {
        final cachedSubcategories = box.get('subcategories') as List<dynamic>;
        return cachedSubcategories
            .where((item) => item is List)
            .map((subcategoryArray) => subcategoryArray
                .map((item) => Subcategory.fromJson(item))
                .toList())
            .toList()
            .take(8)
            .toList();
      } else {
        throw Exception('Failed to fetch categories: $e');
      }
    }
  }
}

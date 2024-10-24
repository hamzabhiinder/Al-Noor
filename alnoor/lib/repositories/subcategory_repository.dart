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
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}

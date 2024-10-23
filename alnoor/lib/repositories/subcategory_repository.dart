import 'dart:convert';
import 'package:alnoor/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/subcategory_dao.dart';

class SubcategoryRepository {
  final String apiUrl = 'https://alnoormdf.com/alnoor/all-categories';
  final SubcategoryDao subcategoryDao = SubcategoryDao();

  // Check internet connectivity
  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<dynamic>> fetchSubcategories() async {
    bool isConnected = await _isConnected();
    print('Connectivity status: $isConnected');

    if (isConnected) {
      // Online - fetch from API
      try {
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          Map<String, dynamic> map = json.decode(response.body);
          List<dynamic> data = map["data"];
          List<Subcategory> subcategories = [];

          for (var subcategoryArray in data) {
            if (subcategoryArray is List) {
              subcategories.addAll(subcategoryArray
                  .map((item) => Subcategory.fromJson(item))
                  .toList());
            }
          }

          // Store subcategories locally
          await subcategoryDao.insertOrUpdateSubcategories(subcategories);

          // Process the limited subcategories as per your original logic
          List limitedSubcategories = subcategories.take(8).toList();

          if (limitedSubcategories.length >= 8) {
            var temp = limitedSubcategories[1];
            limitedSubcategories[1] = limitedSubcategories[7];
            limitedSubcategories[7] = temp;
          }

          return [[], [], [], [], [], [], [], limitedSubcategories[7]];
        } else {
          throw Exception('Failed to load subcategories');
        }
      } catch (e) {
        print('Error fetching subcategories online: $e');
        // Optionally, fall back to local data
        return await _fetchSubcategoriesFromLocal();
      }
    } else {
      // Offline - fetch from local database
      return await _fetchSubcategoriesFromLocal();
    }
  }

  Future<List<dynamic>> _fetchSubcategoriesFromLocal() async {
    print('Fetching subcategories from local database');
    List<Subcategory> subcategories = await subcategoryDao.getSubcategories();

    // Process the limited subcategories as per your original logic
    List limitedSubcategories = subcategories.take(8).toList();

    if (limitedSubcategories.length >= 8) {
      var temp = limitedSubcategories[1];
      limitedSubcategories[1] = limitedSubcategories[7];
      limitedSubcategories[7] = temp;
    }

    return [[], [], [], [], [], [], [], limitedSubcategories[7]];
  }
}

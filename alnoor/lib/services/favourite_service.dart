import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _favouritesKey = 'offline_favourites';

  static const String _imagesKey = 'offline_images';

  // Save favourites to SharedPreferences
  Future<void> saveFavourite(String productId, String collectionName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favourites = prefs.getStringList(_favouritesKey) ?? [];

    // Add new favourite as JSON string
    Map<String, String> favouriteItem = {
      'product_id': productId,
      'collection_name': collectionName,
    };
    favourites.add(jsonEncode(favouriteItem));

    await prefs.setStringList(_favouritesKey, favourites);
  }

  // Get favourites from SharedPreferences
  Future<List<Map<String, String>>> getFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favourites = prefs.getStringList(_favouritesKey) ?? [];

    // Convert each JSON string back to a Map
    return favourites.map((item) {
      return Map<String, String>.from(jsonDecode(item));
    }).toList();
  }

  // Remove synced favourites from SharedPreferences
  Future<void> clearFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favouritesKey);
  }
}

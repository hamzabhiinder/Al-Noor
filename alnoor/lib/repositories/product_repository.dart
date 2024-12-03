import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'package:alnoor/utils/globals.dart' as globals;

class ProductRepository {
  Future<List<Product>> fetchProducts(search, categories, subcategories) async {
    var response = null;
    String curlCommand = '';

    List<Product> localProducts = await _fetchProductsFromLocal();

    // If search query is provided
    if (search.isNotEmpty) {
      String url = "https://alnoormdf.com/alnoor/search/${search}";
      curlCommand = 'curl -X GET "$url" -H "Accept: application/json"';
      print("cURL Command: $curlCommand");

      response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      globals.done = true;
    }
    // If categories are provided
    else if (categories.isNotEmpty) {
      if (subcategories.isNotEmpty) {
        String url =
            "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&sc_id=${subcategories.join(',')}&page=${globals.page}";
        curlCommand = 'curl -X GET "$url" -H "Accept: application/json"';
        print("cURL Command: $curlCommand");

        response =
            await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      } else {
        String url =
            "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&page=${globals.page}";
        curlCommand = 'curl -X GET "$url" -H "Accept: application/json"';
        print("cURL Command: $curlCommand");

        response =
            await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      }
    }
    // If no search or category is provided (fetch all products)
    else {
      // If products exist in local storage, return them first
      if (localProducts.isNotEmpty) {
        globals.products = localProducts;
        return localProducts;
      }

      String url = 'https://alnoormdf.com/alnoor/all-products';
      curlCommand = 'curl -X GET "$url" -H "Accept: application/json"';
      print("cURL Command: $curlCommand");

      response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      globals.done = true;
    }

    // Process the response
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> productsJson = data['data'];

      if (productsJson.isEmpty) {
        globals.done = true;
      }

      // Store product data in shared preferences for offline access
      await _storeProductsInLocal(productsJson);

      globals.products = [
        ...globals.products,
        ...productsJson.map((product) => Product.fromJson(product)).toList()
      ];

      return globals.products;
    } else {
      throw Exception('Failed to load products');
    }
  }
  // Future<List<Product>> fetchProducts(search, categories, subcategories) async {
  //   // // Check if products are already stored in local storage
  //   // List<Product> localProducts = await _fetchProductsFromLocal();

  //   // // If products exist in local storage, return them first
  //   // if (localProducts.isNotEmpty) {
  //   //   globals.products = localProducts;
  //   //   return localProducts;
  //   // }
  //   var response = null;
  //   if (search != "") {
  //     response = await http
  //         .get(Uri.parse("https://alnoormdf.com/alnoor/search/${search}"))
  //         .timeout(Duration(seconds: 60));
  //     globals.done = true;
  //   } else if (categories.length != 0) {
  //     if (subcategories.length != 0) {
  //       response = await http
  //           .get(Uri.parse(
  //               "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&sc_id=${subcategories.join(',')}&page=${globals.page}"))
  //           .timeout(Duration(seconds: 60));
  //     } else {
  //       response = await http
  //           .get(Uri.parse(
  //               "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&page=${globals.page}"))
  //           .timeout(Duration(seconds: 60));
  //     }
  //   } else {
  //     response = await http
  //         .get(Uri.parse('https://alnoormdf.com/alnoor/all-products'))
  //         .timeout(Duration(seconds: 60));
  //     globals.done = true;
  //   }

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     List<dynamic> productsJson = data['data'];
  //     if (productsJson
  //             .map((product) => Product.fromJson(product))
  //             .toList()
  //             .length ==
  //         0) {
  //       globals.done = true;
  //     }

  //     // Store product data in shared preferences for offline access
  //     await _storeProductsInLocal(productsJson);
  //     globals.products = [
  //       ...globals.products,
  //       ...productsJson.map((product) => Product.fromJson(product)).toList()
  //     ];
  //     return globals.products;
  //   } else {
  //     // return await _fetchProductsFromLocal();
  //     throw Exception('Failed to load products');
  //   }
  // }

  Future<void> _storeProductsInLocal(List<dynamic> productsJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('products');
    List<String> productListJson =
        productsJson.map((product) => jsonEncode(product)).toList();
    await prefs.setStringList('products', productListJson);
  }

  // Fetch products from SharedPreferences
  Future<List<Product>> _fetchProductsFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productsJson = prefs.getStringList('products');

    if (productsJson != null) {
      List<Product> products = productsJson
          .map((productJson) => Product.fromJson(jsonDecode(productJson)))
          .toList();
      return products;
    } else {
      return [];
      throw Exception('No products found in local storage');
    }
  }
}

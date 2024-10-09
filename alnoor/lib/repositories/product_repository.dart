// repositories/product_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alnoor/models/product.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/product_dao.dart';

class ProductRepository {
  final ProductDao productDao = ProductDao();

  // Check internet connectivity
  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Product>> fetchProducts(
      String search, List<dynamic> categories, List<dynamic> subcategories) async {
    bool isConnected = await _isConnected();
    print('Connectivity status: $isConnected');

    if (isConnected) {
      // Online - fetch from API
      try {
        var response;
        if (search.isNotEmpty) {
          response = await http.get(
            Uri.parse("https://alnoormdf.com/alnoor/search/$search"),
          );
          globals.done = true;
        } else if (categories.isNotEmpty) {
          if (subcategories.isNotEmpty) {
            response = await http.get(
              Uri.parse(
                  "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&sc_id=${subcategories.join(',')}&page=${globals.page}"),
            );
          } else {
            response = await http.get(
              Uri.parse(
                  "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&page=${globals.page}"),
            );
          }
        } else {
          response = await http.get(
            Uri.parse('https://alnoormdf.com/alnoor/all-products'),
          );
          globals.done = true;
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          List<dynamic> productsJson = data['data'];
          if (productsJson
                  .map((product) => Product.fromJson(product))
                  .toList()
                  .isEmpty) {
            globals.done = true;
          }
          List<Product> products = productsJson
              .map((product) => Product.fromJson(product))
              .toList();

          // Store products locally
          await productDao.insertOrUpdateProducts(products);

          // Update global products
          globals.products = [...globals.products, ...products];

          return globals.products;
        } else {
          throw Exception('Failed to load products');
        }
      } catch (e) {
        print('Error fetching products online: $e');
        // Optionally, fall back to local data
        return await _fetchProductsFromLocal();
      }
    } else {
      // Offline - fetch from local database
      return await _fetchProductsFromLocal();
    }
  }

  Future<List<Product>> _fetchProductsFromLocal() async {
    print('Fetching products from local database');
    List<Product> products = await productDao.getProducts();
    globals.products = products;
    return products;
  }
}

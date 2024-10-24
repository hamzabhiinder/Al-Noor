import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/product.dart';
import 'package:alnoor/utils/globals.dart' as globals;

class ProductRepository {
  Future<List<Product>> fetchProducts(search, categories, subcategories) async {
    var response = null;
    var box = Hive.box('productsBox');
    if (search != "") {
      response = await http
          .get(Uri.parse("https://alnoormdf.com/alnoor/search/${search}"))
          .timeout(Duration(seconds: 60));
      globals.done = true;
    } else if (categories.length != 0) {
      if (subcategories.length != 0) {
        response = await http
            .get(Uri.parse(
                "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&sc_id=${subcategories.join(',')}&page=${globals.page}"))
            .timeout(Duration(seconds: 60));
      } else {
        response = await http
            .get(Uri.parse(
                "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&page=${globals.page}"))
            .timeout(Duration(seconds: 60));
      }
    } else {
      response = await http
          .get(Uri.parse('https://alnoormdf.com/alnoor/all-products'))
          .timeout(Duration(seconds: 60));
      globals.done = true;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> productsJson = data['data'];
      if (productsJson
              .map((product) => Product.fromJson(product))
              .toList()
              .length ==
          0) {
        globals.done = true;
      }
      globals.products = [
        ...globals.products,
        ...productsJson.map((product) => Product.fromJson(product)).toList()
      ];
      await box.put('products', productsJson); // Save fetched data to Hive
      return globals.products;
    } else {
      if (box.containsKey('products')) {
        final cachedProducts = box.get('products') as List<dynamic>;
        return cachedProducts
            .map((item) => Product.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    }
  }
}

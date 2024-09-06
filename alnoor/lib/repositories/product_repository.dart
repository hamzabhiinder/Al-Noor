import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts(search, categories, subcategories) async {
    var response = null;
    if (search != "") {
      response = await http
          .get(Uri.parse("https://alnoormdf.com/alnoor/search/${search}"))
          .timeout(Duration(seconds: 60));
    } else if (categories.length != 0) {
      if (subcategories.length != 0) {
        print(
            "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&sc_id=${subcategories.join(',')}");
        response = await http
            .get(Uri.parse(
                "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&sc_id=${subcategories.join(',')}"))
            .timeout(Duration(seconds: 60));
      } else {
        response = await http
            .get(Uri.parse(
                "https://alnoormdf.com/api/products?c_id=${categories.join(',')}"))
            .timeout(Duration(seconds: 60));
      }
    } else {
      response = await http
          .get(Uri.parse('https://alnoormdf.com/alnoor/all-products'))
          .timeout(Duration(seconds: 60));
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> productsJson = data['data'];
      return productsJson.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

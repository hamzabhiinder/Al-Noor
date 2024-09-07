import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts(String search, List<dynamic> categories,
      List<dynamic> subcategories) async {
    List<Product> allProducts = [];
    int page = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      http.Response? response;
      if (search.isNotEmpty) {
        response = await http
            .get(Uri.parse("https://alnoormdf.com/alnoor/search/$search"))
            .timeout(Duration(seconds: 60));
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          List<dynamic> productsJson = data['data'];

          allProducts =
              productsJson.map((product) => Product.fromJson(product)).toList();
          hasMorePages = false;
        }
      } else if (categories.isNotEmpty) {
        String url =
            "https://alnoormdf.com/api/products?c_id=${categories.join(',')}&page=$page";

        if (subcategories.isNotEmpty) {
          url += "&sc_id=${subcategories.join(',')}";
        }
        response =
            await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          List<dynamic> productsJson = data['data'];

          if (productsJson.isNotEmpty) {
            allProducts.addAll(productsJson
                .map((product) => Product.fromJson(product))
                .toList());
            page++;
          } else {
            hasMorePages = false;
          }
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        response = await http
            .get(Uri.parse('https://alnoormdf.com/alnoor/all-products'))
            .timeout(Duration(seconds: 60));

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          List<dynamic> productsJson = data['data'];

          allProducts =
              productsJson.map((product) => Product.fromJson(product)).toList();
          hasMorePages = false;
        } else {
          throw Exception('Failed to load products');
        }
      }
    }

    return allProducts;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts(search, category) async {
    var response = null;
    if (search != "") {
      response = await http
          .get(Uri.parse("https://alnoormdf.com/alnoor/search/${search}"));
    } else if (category != "") {
      response = await http.get(
          Uri.parse("https://alnoormdf.com/api/products?c_id=${category}"));
    } else {
      response = await http
          .get(Uri.parse('https://alnoormdf.com/alnoor/all-products'));
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

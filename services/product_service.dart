import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductService {
  final String apiUrl = 'https://austin-b.onrender.com/product';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

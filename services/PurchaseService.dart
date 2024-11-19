import 'dart:convert';
import 'package:austins/models/Purchase.dart';
import 'package:http/http.dart' as http;

class PurchaseService {
  final String baseUrl = 'https://austin-b.onrender.com'; // Cambia esto a tu base URL

  Future<List<Purchase>> fetchPurchases(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/publicR/compras/$userId'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((purchase) => Purchase.fromJson(purchase)).toList();
      } else {
        throw Exception('Error al cargar las compras');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

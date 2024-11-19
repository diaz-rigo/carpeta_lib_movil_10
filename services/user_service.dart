import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'https://austin-b.onrender.com';

  Future<Map<String, dynamic>> fetchUserByEmail(String email) async {
    final url = Uri.parse('$_baseUrl/user/email/$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodificar el JSON de la respuesta
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Error al obtener usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      rethrow;
    }
  }
Future<List<dynamic>> fetchPurchasesByUserId(String userId) async {
  // Asegúrate de que esta función maneje errores y devuelva siempre una lista.
  try {
        // final response = Uri.parse('$_baseUrl/publicR/compras/$userId');

    final response = await http.get( Uri.parse('$_baseUrl/publicR/compras/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      print("Error al obtener compras: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Excepción al obtener compras: $e");
    return [];
  }
}

  // // Método para obtener las compras del usuario por ID
  // Future<List<dynamic>> fetchPurchasesByUserId(String userId) async {
  //   final url = Uri.parse('$_baseUrl/publicR/compras/$userId');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print('Error al obtener compras: ${response.statusCode}');
  //     return []; // Devuelve una lista vacía en lugar de null.
  //   }
  // }
}

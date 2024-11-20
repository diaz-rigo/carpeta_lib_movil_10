import 'package:austins/provider/user_provider.dart';
import 'package:austins/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  late Future<List<dynamic>> purchases;

  Future<List<dynamic>> fetchPurchases() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.userEmail;

    if (email == null) {
      throw Exception("El email del usuario no está disponible.");
    }

    try {
      final userDetails = await UserService().fetchUserByEmail(email);
      if (userDetails.containsKey('_id')) {
        final purchases =
            await UserService().fetchPurchasesByUserId(userDetails['_id']);
        return purchases;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception("Error al cargar las compras.");
    }
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final response = await http.get(
      Uri.parse('https://austin-b.onrender.com/product/$productId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al cargar los detalles del producto.");
    }
  }

  @override
  void initState() {
    super.initState();
    purchases = fetchPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras'),
        backgroundColor: const Color.fromARGB(255, 248, 210, 187),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: purchases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay compras disponibles.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final purchase = data[index];
              final details = purchase['details'][0];
              final totalAmount = details['totalAmount'];
              final deliveryType = details['deliveryType'];
              final status = details['status'];
              final products = details['products'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.shopping_cart,
                      color: status == "PAID"
                          ? Colors.green
                          : Colors.redAccent),
                  title: Text(
                    "Total: \$${totalAmount.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tipo de entrega: $deliveryType"),
                      Text("Estado: $status"),
                      Text("Cantidad de productos: ${products.length}"),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    for (var product in products) {
                      try {
                        final productDetails =
                            await fetchProductDetails(product['product']);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(productDetails['name']),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  productDetails['images'][0],
                                  height: 150,
                                ),
                                const SizedBox(height: 10),
                                Text("Descripción: ${productDetails['description']}"),
                                Text("Precio: \$${productDetails['price']}"),
                                Text("Categoría: ${productDetails['category']}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text("Cerrar"),
                              ),
                            ],
                          ),
                        );
                      } catch (error) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Error"),
                            content: Text(
                                "No se pudieron cargar los detalles del producto: $error"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text("Cerrar"),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

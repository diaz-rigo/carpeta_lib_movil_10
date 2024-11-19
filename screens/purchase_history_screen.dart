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

  // URL de la API

  // Función para obtener datos desde la API

  Future<List<dynamic>> fetchPurchases() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.userEmail;

    if (email == null) {
      throw Exception("El email del usuario no está disponible.");
    }

    try {
      // Fetch user details by email
      final userDetails = await UserService().fetchUserByEmail(email);

      if (userDetails.containsKey('_id')) {
        // Fetch purchases for the user
        final purchases =
            await UserService().fetchPurchasesByUserId(userDetails['_id']);

        // Logging for debug
        print("Compras obtenidas: $purchases");
        print("Cantidad total de compras: ${purchases.length}");

        return purchases;
      } else {
        print("No se encontró un ID de usuario válido.");
        return [];
      }
    } catch (error) {
      print("Error al obtener las compras: $error");
      throw Exception("Error al cargar las compras.");
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
        // backgroundColor: Colors.pinkAccent,
        // 
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
                  leading: const Icon(Icons.shopping_cart, color: Color.fromARGB(255, 255, 140, 64)),
                  title: Text(
                    "Total: \$${totalAmount.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tipo de entrega: $deliveryType"),
                      Text("Estado: $status"),
                      ...products.map<Widget>((product) {
                        return Text("- Producto ID: ${product['product']}");
                      }).toList(),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Acción al tocar un elemento de la lista
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Detalles de la Compra"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total: \$${totalAmount.toString()}"),
                            Text("Tipo de entrega: $deliveryType"),
                            Text("Estado: $status"),
                            ...products.map<Widget>((product) {
                              return Text("- Producto ID: ${product['product']}");
                            }).toList(),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cerrar"),
                          ),
                        ],
                      ),
                    );
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

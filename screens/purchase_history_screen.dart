import 'package:austins/provider/user_provider.dart';
import 'package:austins/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
void showProductDetailsModal(BuildContext context, String productId) async {
  try {
    final productDetails = await fetchProductDetails(productId);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDE8E8), Color(0xFFF8D6D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      productDetails['name'] ?? 'Producto',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D4C41),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFE7C4C4),
                    thickness: 1,
                    height: 20,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Descripción:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    productDetails['description'] ?? 'No disponible',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Precio:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    "\$${productDetails['price']?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Categoría:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    productDetails['category'] ?? 'No especificada',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  productDetails['images'] != null &&
                          productDetails['images'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            productDetails['images'][0],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            "Sin imagen disponible",
                            style: TextStyle(
                              color: Colors.brown[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE7C4C4),
                        foregroundColor: Colors.white,
                        shadowColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cerrar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
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
              final deliveryDate = DateFormat('dd/MM/yyyy HH:mm')
                  .format(DateTime.parse(details['deliveryDate']));
              final createdAt = DateFormat('dd/MM/yyyy HH:mm')
                  .format(DateTime.parse(details['createdAt']));
              final trackingNumber = purchase['trackingNumber'];
               final products = details['products'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color.fromARGB(255, 255, 240, 225),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            status == "PAID"
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: status == "PAID"
                                ? Colors.green
                                : Colors.redAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Compra #${index + 1}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "\$${totalAmount.toString()}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
              Text("Número de seguimiento: $trackingNumber"),
                Text("Fecha de entrega: $deliveryDate"),
                Text("Estado: $status"),
                Text("Tipo de entrega: $deliveryType"),
                Text("Fecha de compra: $createdAt"),
                const SizedBox(height: 10),
                ...products.map<Widget>((product) {
                  final productId = product['product']; // Acceso al ID del producto
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      iconColor: const Color.fromARGB(255, 248, 180, 140),
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showProductDetailsModal(context, productId);
                    },
                    icon: const Icon(Icons.info),
                    label: const Text("Ver detalles de producto"),
                  );
                }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

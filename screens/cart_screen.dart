import 'package:austins/models/cart.dart';
// import 'package:austins/widgets/checkout_button.dart'; // Importa el widget de botón de pago
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrito de Compras',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 248, 210, 187), // Color pastel suave
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                'Tu carrito está vacío.',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        color: Colors.pink[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(item.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: \$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Cantidad: ${item.quantity}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.pink[400]),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                    cart.saveCartToPreferences();
                                    cart.notifyListeners();
                                  } else {
                                    cart.removeItem(item.id);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cart.removeItem(item.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.pink[400]),
                                onPressed: () {
                                  item.quantity++;
                                  cart.saveCartToPreferences();
                                  cart.notifyListeners();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      // CheckoutButton(cartItems: cart.items), // Usa CheckoutButton en lugar del botón de "Pagar"
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:austins/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<void> deleteUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
}

Future<bool> checkUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('userId');
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ]);  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    isLoggedIn = await checkUserSession();
    setState(() {}); // Actualiza el estado para reflejar el ícono correspondiente
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrito de Compras',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
// Color.fromARGB(255, 248, 210, 187)        
                backgroundColor: const Color.fromARGB(255, 248, 210, 187),
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          bool isAuthenticated = await checkUserSession();

                          if (isAuthenticated) {
                            Navigator.pushNamed(context, '/checkout');
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Inicia sesión'),
                                content: Text(
                                  'Para continuar con el pago, inicia sesión o procede como invitado.',
                                ),
                                actions: <Widget>[
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.login),
                                    label: Text("Iniciar sesión con Google"),
                                    onPressed: () async {
                                      try {
                                        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
                                        if (googleUser != null) {
                                          await saveUserSession(googleUser.id);
                                          setState(() {
                                            isLoggedIn = true;
                                          });
                                          Navigator.of(context).pop(); // Cierra el modal
                                        }
                                      } catch (error) {
                                        print("Error de autenticación: $error");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    child: Text('Invitado'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/guestCheckout');
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text('Pagar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

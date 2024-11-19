import 'package:austins/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class AuthenticatedCheckoutScreen extends StatefulWidget {
  @override
  _AuthenticatedCheckoutScreenState createState() =>
      _AuthenticatedCheckoutScreenState();
}

class _AuthenticatedCheckoutScreenState
    extends State<AuthenticatedCheckoutScreen> {
  StreamSubscription? _linkSubscription;
  final _formKey = GlobalKey<FormState>();
  String _instruction = '';
  String _tipoEntrega = 'Envío';
  List<Map<String, dynamic>> _cartProducts = [];
  double _totalneto = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeUserSession();
    _loadCartData();
    _listenToIncomingLinks();
  }

  void _listenToIncomingLinks() {
    _linkSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.path == '/checkout/success') {
          Navigator.pushNamed(context, '/orderSuccess');
        } else if (uri.path == '/checkout/cancel') {
          Navigator.pushNamed(context, '/orderDetail');
        }
      }
    }, onError: (err) {
      print('Error al escuchar el enlace: $err');
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');

    if (cartData != null) {
      List<dynamic> decodedData = jsonDecode(cartData);
      setState(() {
        _cartProducts =
            decodedData.map((item) => item as Map<String, dynamic>).toList();
        _totalneto = _cartProducts.fold(
            0.0, (sum, item) => sum + (item['price'] * item['quantity']));
      });
    }
  }

  Future<void> _createSession(UserProvider userProvider) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_cartProducts.isEmpty || _totalneto <= 0 || userProvider.userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El carrito está vacío o no es válido.')),
      );
      return;
    }

    final datosCliente = {
      "name": userProvider.userName ?? 'Usuario',
      "email": userProvider.userEmail ?? 'Correo no disponible',
    };

    final body = jsonEncode({
      "totalneto": _totalneto,
      "tipoEntrega": _tipoEntrega,
      "dateselect": DateTime.now().toString(),
      "productos": _cartProducts,
      "datoscliente": datosCliente,
      "instruction": _instruction,
      "success_url": "https://austins.vercel.app/payment/order-success",
      "cancel_url": "https://austins.vercel.app/payment/order-detail",
    });

    try {
      final response = await http.post(
        Uri.parse('https://austin-b.onrender.com/stripe/create-checkout-session-flutter'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final sessionData = jsonDecode(response.body);
        final sessionUrl = sessionData['url'];
        if (sessionUrl != null) {
          Navigator.pushNamed(context, '/checkout', arguments: sessionUrl);
        }
      } else {
        throw Exception('Error al crear sesión: ${response.body}');
      }
    } catch (error) {
      print("Error en la sesión de pago: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Autenticado'),
        backgroundColor: Color(0xFFF8D2BB), // Rosa suave (repotería)
        elevation: 4.0, // Agregar sombra para más profundidad
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del usuario con diseño mejorado
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: userProvider.userPhotoUrl?.isNotEmpty ?? false
                          ? NetworkImage(userProvider.userPhotoUrl!)
                          : null,
                      backgroundColor: Color(0xFFF8D2BB), // Fondo en tono pastel
                      child: (userProvider.userPhotoUrl?.isEmpty ?? true)
                          ? Text(
                              userProvider.userName?.isNotEmpty ?? false
                                  ? userProvider.userName![0].toUpperCase()
                                  : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 12), // Más espacio entre avatar y texto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${userProvider.userName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700], // Color marrón claro
                          ),
                        ),
                        Text(
                          '${userProvider.userEmail}' ?? 'Correo no disponible',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Instrucciones Adicionales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildTextField(
                  icon: Icons.note,
                  labelText: 'Ej: sin nuez en el pastel',
                  hintText: 'Escribe alguna instrucción especial',
                  onSave: (value) => _instruction = value ?? '',
                ),
                SizedBox(height: 20),
                Text(
                  'Resumen del Carrito',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = _cartProducts[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Bordes más redondeados
                      ),
                      child: ListTile(
                        leading: Image.network(product['imageUrl'], width: 50, height: 50),
                        title: Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800], // Color más fuerte para el nombre
                          ),
                        ),
                        subtitle: Text(
                            'Cantidad: ${product['quantity']} - Precio: \$${product['price']}'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Total: \$$_totalneto',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[600], // Marrón suave para el total
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _createSession(userProvider),
                    icon: Icon(Icons.payment),
                    label: Text('Pagar Ahora'),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Color(0xFF2C6D98), // Azul atractivo
                      iconColor: Colors.white, 
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String labelText,
    required String hintText,
    required Function(String?) onSave,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Color(0xFFF8D2BB), // Color de fondo suave
      ),
      onSaved: onSave,
    );
  }
}

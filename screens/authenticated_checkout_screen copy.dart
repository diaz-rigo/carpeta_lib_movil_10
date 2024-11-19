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
  // Map<String, String> _userData = {};

  @override

  void initState() {
    super.initState();
    _initializeUserSession();
    _loadCartData();
      _listenToIncomingLinks(); // Inicia la escucha de enlaces

  }
    void _listenToIncomingLinks() {
      print("se ejecuto**************************************");
    _linkSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.path == '/checkout/success') {
          // Redirige a la pantalla de éxito
          Navigator.pushNamed(context, '/orderSuccess');
        } else if (uri.path == '/checkout/cancel') {
          // Redirige a la pantalla de detalles
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
    setState(() {
      // _userData = {
      //   "userName": prefs.getString("userName") ?? "Usuario",
      //   "userEmail": prefs.getString("userEmail") ?? "Correo no disponible",
      //   "userPhotoUrl": prefs.getString("userPhotoUrl") ?? "",
      //   "userPhone": prefs.getString("userPhone") ?? "Teléfono no disponible",
      // };
    });
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
    print("Faltan datos esenciales para crear la sesión.");
    return;
  }
if (_cartProducts.isEmpty || _totalneto <= 0) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('El carrito está vacío o no es válido.')),
  );
  return;
}

  final datosCliente = {
    "name": userProvider.userName ?? 'Usuario',
    "paternalLastname": 'Apellido1', // Valor por defecto
    "maternalLastname": 'Apellido2', // Valor por defecto
    "phone": 'No proporcionado',
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
      Uri.parse(
          'https://austin-b.onrender.com/stripe/create-checkout-session-flutter'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print("-------------------------------------------<<<<<<<<<||||||||||||||||||||||||||||||||||");
    print(body);

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
    print(
        "------------------------------------------------------------------------------------------------");
    print(userProvider.userEmail);
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Autenticado'),
        backgroundColor: const Color.fromARGB(255, 248, 210, 187),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (!(userProvider.userEmail?.isNotEmpty ?? false))
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (userProvider.userPhotoUrl?.isNotEmpty ?? false)
                              ? NetworkImage(userProvider.userPhotoUrl!)
                              : null,
                      backgroundColor:
                          Colors.blue, // Color de fondo si no hay foto
                      child: (userProvider.userPhotoUrl?.isEmpty ?? true)
                          ? Text(
                              userProvider.userName?.isNotEmpty ?? false
                                  ? userProvider.userName![0]
                                      .toUpperCase() // Inicial del nombre
                                  : '',
                              style: TextStyle(
                                color:
                                    Colors.white, // Color del texto (inicial)
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),

                    SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${userProvider.userName}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('${userProvider.userEmail}' ??
                            'Correo no disponible'),
                      ],
                    ),
            
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Instrucciones Adicionales',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    return ListTile(
                      leading: Image.network(product['imageUrl']),
                      title: Text(product['name']),
                      subtitle: Text(
                          'Cantidad: ${product['quantity']} - Precio: \$${product['price']}'),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Total: \$$_totalneto',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[600]),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _createSession(userProvider),
                    icon: Icon(Icons.payment),
                    label: Text('Pagar Ahora'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
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
    required FormFieldSetter<String> onSave,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
        hintText: hintText,
      ),
      onSaved: onSave,
    );
  }
}

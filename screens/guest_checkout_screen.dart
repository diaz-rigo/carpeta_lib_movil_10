import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GuestCheckoutScreen extends StatefulWidget {
  @override
  _GuestCheckoutScreenState createState() => _GuestCheckoutScreenState();
}

class _GuestCheckoutScreenState extends State<GuestCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _paternalLastname = '';
  String _maternalLastname = '';
  String _email = '';
  String _phone = '';
  String _tipoEntrega = 'Envío';
  String _instruction = '';
  List<Map<String, dynamic>> _cartProducts = [];
  double _totalneto = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');

    if (cartData != null) {
      List<dynamic> decodedData = jsonDecode(cartData);
      _cartProducts = decodedData.map((item) => item as Map<String, dynamic>).toList();
      _totalneto = _cartProducts.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
      setState(() {});
    }
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final datoscliente = {
      "name": _name,
      "paternalLastname": _paternalLastname,
      "maternalLastname": _maternalLastname,
      "phone": _phone,
      "email": _email,
    };

    final body = jsonEncode({
      "totalneto": _totalneto,
      "tipoEntrega": _tipoEntrega,
      "dateselect": DateTime.now().toString(),
      "productos": _cartProducts,
      "datoscliente": datoscliente,
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
        throw Exception('Error al crear sesión');
      }
    } catch (error) {
      print("Error en la sesión de pago: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout como Invitado'),
        backgroundColor: const Color.fromARGB(255, 248, 210, 187),
      ),
      body: SingleChildScrollView( // Aquí envuelves el contenido en un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información del Cliente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 248, 210, 187)),
                ),
                _buildTextField(
                  icon: Icons.person,
                  labelText: 'Nombre',
                  hintText: 'Ingresa tu nombre',
                  onSave: (value) => _name = value!,
                ),
                _buildTextField(
                  icon: Icons.person_outline,
                  labelText: 'Apellido Paterno',
                  hintText: 'Ingresa tu apellido paterno',
                  onSave: (value) => _paternalLastname = value!,
                ),
                _buildTextField(
                  icon: Icons.person_outline,
                  labelText: 'Apellido Materno',
                  hintText: 'Ingresa tu apellido materno',
                  onSave: (value) => _maternalLastname = value!,
                ),
                _buildTextField(
                  icon: Icons.email,
                  labelText: 'Correo Electrónico',
                  hintText: 'Ingresa tu correo electrónico',
                  onSave: (value) => _email = value!,
                ),
                _buildTextField(
                  icon: Icons.phone,
                  labelText: 'Teléfono',
                  hintText: 'Ingresa tu número de teléfono',
                  onSave: (value) => _phone = value!,
                ),
                _buildTextField(
                  icon: Icons.note,
                  labelText: 'Instrucciones Adicionales',
                  hintText: 'Ej: sin nuez en el pastel',
                  onSave: (value) => _instruction = value ?? '',
                ),
                SizedBox(height: 20),
                Text(
                  'Resumen del Carrito',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 248, 210, 187)),
                ),
                ListView.builder(
                  shrinkWrap: true, // Evita overflow al ajustar el ListView al contenido
                  physics: NeverScrollableScrollPhysics(), // Desactiva el scroll del ListView
                  itemCount: _cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = _cartProducts[index];
                    return ListTile(
                      leading: Image.network(product['imageUrl']),
                      title: Text(product['name']),
                      subtitle: Text('Cantidad: ${product['quantity']} - Precio: \$${product['price']}'),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Total: \$$_totalneto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[600]),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _createSession,
                    icon: Icon(Icons.payment),
                    label: Text('Pagar Ahora'),
                    style: ElevatedButton.styleFrom(
                      iconColor: Color.fromARGB(255, 248, 210, 187),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
        icon: Icon(icon, color: Color.fromARGB(255, 171, 119, 100)),
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.brown[600]),
      ),
      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
      onSaved: onSave,
    );
  }
}

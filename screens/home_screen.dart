import 'package:austins/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_header.dart';
import '../widgets/carrusel_widget.dart';
import '../widgets/category_buttons.dart';
import '../widgets/product_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ]);  late Future<List<Product>> futureProducts;
  bool isLoggedIn = false; // Variable para indicar si está logueado
  
  // Método para eliminar la sesión del usuario
Future<void> deleteUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  bool removed = await prefs.remove('userId');
  if (!removed) {
    print('Advertencia: no se pudo eliminar el userId de SharedPreferences');
  }
}

  
  // Inicializa la sesión
  Future<void> _initializeSession() async {
    isLoggedIn = await checkUserSession();
    setState(() {}); // Actualiza el estado para reflejar el ícono correspondiente
  }
  
  @override
  void initState() {
    _initializeSession();
    super.initState();
    futureProducts = ProductService().fetchProducts();
  }
void _logoutUser() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    await _googleSignIn.signOut();
    await userProvider.clearUser(); // Limpia datos de memoria y almacenamiento
    setState(() {
      isLoggedIn = false;
    });
    print('Sesión cerrada y datos del usuario eliminados');
  } catch (e) {
    print('Error al cerrar sesión: $e');
  }
}




  final List<String> categories = [
    'Repostería',
    'Panadería',
    'Bebidas',
    'Postres',
  ];

  final List<String> imageList = [
    'https://res.cloudinary.com/dfd0b4jhf/image/upload/v1709327171/public__/mbpozw6je9mm8ycsoeih.jpg',
    'https://res.cloudinary.com/dfd0b4jhf/image/upload/v1709327171/public__/m2z2hvzekjw0xrmjnji4.jpg',
  ];

  void _onCategorySelected(String category) {
    print('Categoría seleccionada: $category');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomHeader(isLoggedIn: isLoggedIn),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 210, 187),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menú Principal',
                    style: TextStyle(color: Colors.brown, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  if (userProvider.userName != null) ...[
                    Text(
                      'Usuario: ${userProvider.userName}',
                      style: TextStyle(color: Colors.brown, fontSize: 16),
                    ),
                    Text(
                      'Correo: ${userProvider.userEmail}',
                      style: TextStyle(color: Colors.brown, fontSize: 14),
                    ),
                  ] else ...[
                    Text(
                      'Usuario no logueado',
                      style: TextStyle(color: Colors.brown, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                _logoutUser(); // Cierra sesión
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CarruselWidget(imageList: imageList),
          const SizedBox(height: 16.0),
          CategoryButtons(
            categories: categories,
            onCategorySelected: _onCategorySelected,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ProductCarousel(
                    products: snapshot.data!.map((product) {
                      return {
                        'id': product.id,
                        'title': product.name,
                        'price': product.price,
                        'imageUrl': product.images.isNotEmpty
                            ? product.images[0]
                            : '',
                      };
                    }).toList(),
                  );
                } else {
                  return const Center(child: Text('No products found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

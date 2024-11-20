import 'package:austins/provider/user_provider.dart';
import 'package:austins/services/user_service.dart';
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
  ]);
  late Future<List<Product>> futureProducts;
  bool isLoggedIn = false; // Variable para indicar si está logueado
  late Future<Map<String, dynamic>> futureUserDetails;
  late Future<List<dynamic>> futureUserPurchases;

  // Método para eliminar la sesión del usuario

  // Inicializa la sesión // Inicializa la sesiónint totalPurchasesCount = 0; // Variable para almacenar la cantidad de compras totales
  int totalPurchasesCount =
      0; // Variable para almacenar la cantidad de compras totales

  Future<void> _initializeSession() async {
    isLoggedIn = await checkUserSession();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // if (isLoggedIn && userProvider.userEmail != null) {
      futureUserDetails =
          UserService().fetchUserByEmail(userProvider.userEmail!);

          print(
              "Compras obtenidas: ----------------------->>>>>>>>>>>>>>>>>>>$futureUserDetails"); // Verifica si devuelve las compras
      futureUserPurchases = futureUserDetails.then((user) async {
        if (user.containsKey('_id')) {
          final purchases =
              await UserService().fetchPurchasesByUserId(user['_id']);
          print(
              "Compras obtenidas: $purchases"); // Verifica si devuelve las compras

          // Actualiza la cantidad total de compras
          setState(() {
            totalPurchasesCount =
                purchases.length; // Cuenta la cantidad de compras
          });
          return purchases;
        }
        return []; // Si no hay ID de usuario, devuelve una lista vacía
      });

      print(
          "----------------------------------------***********************************");
      print("Cantidad total de compras: $totalPurchasesCount");
    // }
  }

  Future<bool> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final id = prefs.getString('id');
    final name = prefs.getString('name');
    final token = prefs.getString('token');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(email!, id!, name!, token!);
    }

    return isLoggedIn;
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
      await userProvider
          .clearUser(); // Limpia datos de memoria y almacenamiento
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
              leading: Icon(Icons.shopping_bag, color: Colors.brown[800]),
              title: const Text('Mis Compras'),
              trailing: FutureBuilder<List<dynamic>>(
                future: isLoggedIn ? futureUserPurchases : Future.value([]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      '0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data!.length}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    );
                  } else {
                    return Text(
                      '0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    );
                  }
                },
              ),
              onTap: () {
                Navigator.pushNamed(context, '/purchases');
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


     body: SingleChildScrollView(  // Agregar un ScrollView para evitar que los elementos se corten
  child: Column(
    children: [
      // Carrusel de imágenes
      CarruselWidget(imageList: imageList),
      const SizedBox(height: 16.0),

      // Botones de categorías
      CategoryButtons(
        categories: categories,
        onCategorySelected: _onCategorySelected,
      ),
      const SizedBox(height: 16.0),

      // Carrousel de productos (con FutureBuilder)
      FutureBuilder<List<Product>>(
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
                  'imageUrl': product.images.isNotEmpty ? product.images[0] : '',
                };
              }).toList(),
            );
          } else {
            return const Center(child: Text('No products found.'));
          }
        },
      ),



const SizedBox(height: 16.0),  // Separador para el pie de página
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Título de la sección "Sobre Nosotros"
      Text(
        'Sobre Nosotros',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: const Color.fromARGB(255, 181, 76, 16), // Color atractivo para el título
          fontWeight: FontWeight.bold,
          fontSize: 24.0, // Tamaño de fuente más grande
        ),
      ),
      const SizedBox(height: 16.0),

      // Descripción de la empresa de repostería
      Text(
        'En Austins, nos especializamos en crear pasteles y postres deliciosos para cualquier ocasión. Con años de experiencia en la repostería artesanal, ofrecemos productos frescos y de calidad.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.brown[700], // Color suave para el texto
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16.0),

      // Título de la sección "Nuestros Productos"
      Text(
        'Nuestros Productos',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: const Color.fromARGB(255, 181, 76, 16),
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
      const SizedBox(height: 16.0),

      // Imagen de algunos productos (pasteles, galletas, etc.)
Container(
  width: double.infinity,
  height: 200,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.network(
      'https://res.cloudinary.com/dfd0b4jhf/image/upload/v1709327171/public__/mbpozw6je9mm8ycsoeih.jpg',
    
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(child: Text('No se pudo cargar la imagen.'));
      },
    ),
  ),
),
const SizedBox(height: 16.0),

      // Título de la sección "Testimonios"
      Text(
        'Testimonios de Clientes',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: const Color.fromARGB(255, 181, 76, 16),
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
      const SizedBox(height: 16.0),

      // Testimonio de cliente
      Text(
        '"El pastel de bodas que pedimos fue un éxito total. ¡Delicioso y hermoso!"\n- Ana G.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.brown[600],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16.0),

      // Título de la sección "Suscripción al Newsletter"
      Text(
        'Suscríbete a nuestro Newsletter',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: const Color.fromARGB(255, 181, 76, 16),
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
      const SizedBox(height: 16.0),

      // Campo de texto para suscripción
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Introduce tu email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
      const SizedBox(height: 16.0),

      // Footer mejorado con enlaces y contacto
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Color(0xFFF8E1D4), // Fondo suave de color pastel
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Text(
              '© 2024 Pastelería Austins',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.brown[700],
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook),
                  color: Colors.blue[600], // Color atractivo para Facebook
                  onPressed: () {
                    // Lógica para abrir el enlace de Facebook
                  },
                  tooltip: 'Facebook',
                ),
                IconButton(
                  icon: const Icon(Icons.facebook),
                  color: Colors.purple[600], // Color atractivo para Instagram
                  onPressed: () {
                    // Lógica para abrir el enlace de Instagram
                  },
                  tooltip: 'Instagram',
                ),
                IconButton(
                  icon: const Icon(Icons.facebook),
                  color: Colors.blue[400], // Color atractivo para Twitter
                  onPressed: () {
                    // Lógica para abrir el enlace de Twitter
                  },
                  tooltip: 'Twitter',
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
),


      ],

    
  ),
),


    );
  }
}

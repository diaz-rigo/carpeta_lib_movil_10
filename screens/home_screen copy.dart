// import 'package:flutter/material.dart';
// import '../services/product_service.dart';
// import '../models/product_model.dart';
// import '../widgets/product_card.dart';
// import '../widgets/custom_header.dart';
// import '../widgets/carrusel_widget.dart'; // Asegúrate de tener esta importación
// import '../widgets/category_buttons.dart'; // Importa el widget de categorías
// import '../widgets/product_carousel.dart'; // Importa el carrusel de productos

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<Product>> futureProducts;

//   @override
//   void initState() {
//     super.initState();
//     futureProducts = ProductService().fetchProducts();
//   }

//   // Lista de categorías de ejemplo
//   final List<String> categories = [
//     'Repostería',
//     'Panadería',
//     'Bebidas',
//     'Postres',
//   ];

//   // Lista de imágenes para el carrusel
//   final List<String> imageList = [
//     'https://res.cloudinary.com/dfd0b4jhf/image/upload/v1709327171/public__/mbpozw6je9mm8ycsoeih.jpg',
//     'https://res.cloudinary.com/dfd0b4jhf/image/upload/v1709327171/public__/m2z2hvzekjw0xrmjnji4.jpg',
//     // Agrega más URLs si es necesario
//   ];

//   void _onCategorySelected(String category) {
//     // Lógica para manejar la selección de categoría (filtrar productos, etc.)
//     print('Categoría seleccionada: $category');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomHeader(isLoggedIn: false),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 248, 210, 187),
//               ),
//               child: Text(
//                 'Menú Principal',
//                 style: TextStyle(color: Colors.brown, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home),
//               title: const Text('Inicio'),
//               onTap: () {
//                 Navigator.pop(context); // Cierra el drawer
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Configuración'),
//               onTap: () {
//                 Navigator.pop(context); // Cierra el drawer
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Cerrar sesión'),
//               onTap: () {
//                 Navigator.pop(context); // Cierra el drawer
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Agrega el CarruselWidget en la parte superior
//           CarruselWidget(imageList: imageList),

//           // Espacio entre el carrusel y la lista de productos
//           const SizedBox(height: 16.0),

//           // Botones de categorías
//           CategoryButtons(
//             categories: categories,
//             onCategorySelected: _onCategorySelected,
//           ),

//           // Espacio entre las categorías y el carrusel de productos
//           const SizedBox(height: 16.0),

//           // Carrusel de productos
//           Expanded(
//             child: FutureBuilder<List<Product>>(
//               future: futureProducts,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                   return ProductCarousel(
//                     products: snapshot.data!.map((product) {
//                       return {
//                         'id': product.id,
//                         'title': product.name,
//                         'price': product.price,
//                         'imageUrl': product.images.isNotEmpty ? product.images[0] : '',
//                       };
//                     }).toList(),
//                   );
//                 } else {
//                   return const Center(child: Text('No products found.'));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

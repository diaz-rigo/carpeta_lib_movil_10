// return Scaffold(
//   appBar: CustomHeader(isLoggedIn: isLoggedIn),
//   drawer: Drawer(
//     child: ListView(
//       padding: EdgeInsets.zero,
//       children: <Widget>[
//         DrawerHeader(
//           decoration: BoxDecoration(
//             color: Color.fromARGB(255, 248, 210, 187),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Menú Principal',
//                 style: TextStyle(color: Colors.brown, fontSize: 24),
//               ),
//               const SizedBox(height: 10),
//               if (userProvider.userName != null) ...[
//                 Text(
//                   'Usuario: ${userProvider.userName}',
//                   style: TextStyle(color: Colors.brown, fontSize: 16),
//                 ),
//                 Text(
//                   'Correo: ${userProvider.userEmail}',
//                   style: TextStyle(color: Colors.brown, fontSize: 14),
//                 ),
//               ] else ...[
//                 Text(
//                   'Usuario no logueado',
//                   style: TextStyle(color: Colors.brown, fontSize: 16),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         ListTile(
//           leading: const Icon(Icons.home),
//           title: const Text('Inicio'),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.shopping_bag, color: Colors.brown[800]),
//           title: const Text('Mis Compras'),
//           trailing: FutureBuilder<List<dynamic>>(
//             future: isLoggedIn ? futureUserPurchases : Future.value([]),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text(
//                   '0',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.brown,
//                   ),
//                 );
//               } else if (snapshot.hasData) {
//                 return Text(
//                   '${snapshot.data!.length}',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.brown,
//                   ),
//                 );
//               } else {
//                 return Text(
//                   '0',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.brown,
//                   ),
//                 );
//               }
//             },
//           ),
//           onTap: () {
//             Navigator.pushNamed(context, '/purchases');
//           },
//         ),
//         ListTile(
//           leading: const Icon(Icons.logout),
//           title: const Text('Cerrar sesión'),
//           onTap: () {
//             Navigator.pop(context); // Cierra el drawer
//             _logoutUser(); // Cierra sesión
//           },
//         ),
//       ],
//     ),
//   ),
//   body: SingleChildScrollView(  // Agregar un ScrollView para evitar que los elementos se corten
//     child: Column(
//       children: [
//         // Carrusel de imágenes
//         CarruselWidget(imageList: imageList),
//         const SizedBox(height: 16.0),

//         // Botones de categorías
//         CategoryButtons(
//           categories: categories,
//           onCategorySelected: _onCategorySelected,
//         ),
//         const SizedBox(height: 16.0),

//         // Carrousel de productos (con FutureBuilder)
//         FutureBuilder<List<Product>>(
//           future: futureProducts,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//               return ProductCarousel(
//                 products: snapshot.data!.map((product) {
//                   return {
//                     'id': product.id,
//                     'title': product.name,
//                     'price': product.price,
//                     'imageUrl': product.images.isNotEmpty ? product.images[0] : '',
//                   };
//                 }).toList(),
//               );
//             } else {
//               return const Center(child: Text('No products found.'));
//             }
//           },
//         ),
//         const SizedBox(height: 16.0),  // Separador para el pie de página

//         // Pie de página (FooterWidget con información estática)
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Título de la sección "Contáctanos"
//               Text(
//                 'Contáctanos',
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   color: Colors.deepPurple, // Color atractivo para el título
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16.0),

//               // Información de contacto estática
//               Container(
//                 padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200], // Fondo suave para la información de contacto
//                   borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'soporte@ejemplo.com',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.black87, // Color oscuro para el texto
//                       ),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Tel: 123-456-7890',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.black87, // Color oscuro para el texto
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16.0),

//               // Enlaces de redes sociales estáticos con iconos mejorados
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.facebook),
//                     color: Colors.blue[600], // Color atractivo para el icono
//                     onPressed: () {
//                       // Aquí podrías usar un paquete como 'url_launcher' para abrir el enlace
//                     },
//                     tooltip: 'Facebook', // Agregar tooltip para mostrar al pasar el mouse
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.instagram),
//                     color: Colors.purple[600], // Color atractivo para Instagram
//                     onPressed: () {
//                       // Aquí podrías usar un paquete como 'url_launcher' para abrir el enlace
//                     },
//                     tooltip: 'Instagram', // Agregar tooltip para mostrar al pasar el mouse
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.twitter),
//                     color: Colors.blue[400], // Color atractivo para Twitter
//                     onPressed: () {
//                       // Aquí podrías usar un paquete como 'url_launcher' para abrir el enlace
//                     },
//                     tooltip: 'Twitter', // Agregar tooltip para mostrar al pasar el mouse
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// );

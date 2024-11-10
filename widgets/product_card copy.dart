// import 'package:flutter/material.dart';
// import '../screens/product_detail_screen.dart'; // Importa la pantalla de detalles del producto correctamente

// class ProductCard extends StatelessWidget {
//   final String id;
//   final String title;
//   final double price;
//   final String imageUrl;

//   const ProductCard({super.key, 
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.all(10.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   // Navegar a la página de detalles del producto
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ProductDetailScreen(productId: id), // Utiliza el nombre correcto de la clase
//                     ),
//                   );
//                 },
//                 child: AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(15.0),
//                       topRight: Radius.circular(15.0),
//                     ),
//                     child: Image.network(
//                       imageUrl,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10.0,
//                 right: 10.0,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.favorite_border,
//                       color: Colors.red,
//                     ),
//                     onPressed: () {
//                       // Aquí puedes manejar la acción de agregar a favoritos
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8.0),
//                 Text(
//                   '\$$price',
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

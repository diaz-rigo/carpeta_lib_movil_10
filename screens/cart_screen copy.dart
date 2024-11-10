// import 'package:austins/models/cart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Asegúrate de agregar el paquete provider en pubspec.yaml

// class CartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cart>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Carrito de Compras'),
//       ),
//       body: cart.items.isEmpty
//           ? Center(
//               child: Text('Tu carrito está vacío.'),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cart.items.length,
//                     itemBuilder: (ctx, index) {
//                       final item = cart.items[index];
//                       return Card(
//                         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                         child: ListTile(
//                           leading: Container(
//                             width: 50, // Ancho del contenedor
//                             height: 50, // Alto del contenedor
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8), // Bordes redondeados
//                               image: DecorationImage(
//                                 image: NetworkImage(item.imageUrl), // Cargar la imagen del producto
//                                 fit: BoxFit.cover, // Ajustar la imagen al contenedor
//                               ),
//                             ),
//                           ),
//                           title: Text(item.name),
//                           subtitle: Text('Precio: \$${item.price.toStringAsFixed(2)}'),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.remove),
//                                 onPressed: () {
//                                   if (item.quantity > 1) {
//                                     item.quantity--;
//                                     cart.saveCartToPreferences();
//                                     cart.notifyListeners();
//                                   } else {
//                                     cart.removeItem(item.id);
//                                   }
//                                 },
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.delete),
//                                 onPressed: () {
//                                   cart.removeItem(item.id);
//                                 },
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.add),
//                                 onPressed: () {
//                                   item.quantity++;
//                                   cart.saveCartToPreferences();
//                                   cart.notifyListeners();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Lógica para proceder al pago
//                           // Puedes navegar a otra pantalla de pago aquí
//                           // Navigator.of(context).pushNamed('/checkout');
//                         },
//                         child: Text('Pagar'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

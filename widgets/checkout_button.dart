// // lib/widgets/checkout_button.dart
// import 'package:austins/models/cart.dart';
// import 'package:austins/services/payment_service.dart';
// import 'package:flutter/material.dart';

// class CheckoutButton extends StatelessWidget {
//   final List<CartItem> cartItems;

//   CheckoutButton({required this.cartItems});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         PaymentService.startCheckout(context, cartItems);
//       },
//       child: Text("Pagar con Stripe"),
//     );
//   }
// }

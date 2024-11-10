// // lib/services/payment_service.dart
// import 'package:austins/models/cart.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';

// class PaymentService {
//   static void initStripe() {
//     // Ya no es necesario configurar aquí, pues se hace en main.dart
//   }

//   static Future<void> startCheckout(BuildContext context, List<CartItem> cartItems) async {
//     final url = Uri.parse('http://localhost:4242/create-checkout-session');
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({'items': cartItems.map((item) => item.toJson()).toList()}),
//     );

//     if (response.statusCode == 200) {
//       final sessionId = jsonDecode(response.body)['id'];
      
//       // Configura las opciones de pago sin currencyCode
//       await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: sessionId,
//         merchantDisplayName: "Tu Nombre o Empresa",
//         style: ThemeMode.system, // Usa tema claro u oscuro basado en el sistema
//       ));

//       // Muestra la hoja de pago
//       await Stripe.instance.presentPaymentSheet().then((paymentResult) {
//         print("Pago completado exitosamente: $paymentResult");
//         Navigator.of(context).pushNamed('/success');
//       }).catchError((error) {
//         print("Error durante el pago: $error");
//         Navigator.of(context).pushNamed('/cancel');
//       });
//     } else {
//       print("Error creando la sesión de pago");
//     }
//   }
// }

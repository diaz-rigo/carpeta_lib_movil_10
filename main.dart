// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:austins/models/cart.dart';
import 'utils/routes.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  // Nos aseguramos de inicializar los widgets de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "tu_stripe_publishable_key"; // Reemplaza con tu clave de Stripe
  // if (!kIsWeb) {
  //   Stripe.publishableKey = 'your-publishable-key';
  //   // Configura Stripe solo si no es una plataforma web.
  // }
  // Creamos una instancia de Cart y cargamos los datos desde SharedPreferences
  final cart = Cart();
  await cart.loadCartFromPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => cart),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Austins',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.home, // Ruta inicial definida en routes.dart
      onGenerateRoute: AppRoutes.generateRoute, // Generador de rutas desde routes.dart
    );
  }
}

import 'package:austins/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String productDetail = '/product';
  static const String cart = '/cart'; // Añadir la ruta del carrito

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case productDetail:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: args['id']),
          );
        }
        return _errorRoute(settings); // Pasa `settings` al manejar el error
      case cart:
        return MaterialPageRoute(builder: (_) => CartScreen()); // Ruta para el carrito
      default:
        return _errorRoute(settings); // Pasa `settings` al manejar el error
    }
  }

  // Cambia a aceptar `RouteSettings` como parámetro
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'), // Accede a `settings.name`
        ),
      ),
    );
  }
}

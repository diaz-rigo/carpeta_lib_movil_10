import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatelessWidget {
  final String sessionUrl;

  CheckoutScreen({required this.sessionUrl});
  Future<void> clearCart() async {


    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart'); // Elimina el carrito almacenado
  }
  Future<void> launchCheckout(BuildContext context) async {
    try {
      await launchUrl(
        Uri.parse(sessionUrl),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Color.fromARGB(255, 248, 210, 187), // Color claro
            navigationBarDividerColor: Colors.brown, // Color secundario más oscuro
            navigationBarColor: Colors.brown, // Color secundario más oscuro
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Color.fromARGB(255, 248, 210, 187), // Color claro en Safari
          preferredControlTintColor: Colors.brown, // Color de los controles en Safari
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint('No se pudo abrir la URL: $sessionUrl. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 210, 187), // Color claro
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.brown), // Ícono personalizado
            SizedBox(width: 8),
            Text('Checkout', style: TextStyle(color: Colors.brown)),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            iconColor: Colors.brown, // Color del botón
            backgroundColor: Color.fromARGB(255, 248, 210, 187), // Color del texto y del ícono
          ),
          icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 223, 131, 73)),
          label: Text('Proceder al pago'),
onPressed: () async {
            // Primero vaciar el carrito
            await clearCart();

            // Luego proceder con el pago
            launchCheckout(context);
          },        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class CheckoutScreen extends StatelessWidget {
  final String sessionUrl;

  CheckoutScreen({required this.sessionUrl});

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 210, 187), // Color claro
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.brown), // Ícono personalizado
            SizedBox(width: 8),
            const Text('Checkout', style: TextStyle(color: Colors.brown)), // Color del texto
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton.icon( // Botón con ícono y texto
          style: ElevatedButton.styleFrom(
            iconColor: Colors.brown, // Color del botón
            backgroundColor: Color.fromARGB(255, 248, 210, 187), // Color del texto y del ícono
          ),
          icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 223, 131, 73)), // Ícono en el botón
          label: const Text('Proceder al pago'),
          onPressed: () => launchCheckout(context),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final Map<String, String> contactInfo; // Información de contacto, como email y teléfono
  final List<String> socialLinks; // Enlaces de redes sociales

  const FooterWidget({
    Key? key,
    required this.contactInfo,
    required this.socialLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título de la sección
          Text(
            'Contáctanos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),

          // Mostrar correo electrónico si está disponible
          if (contactInfo.containsKey('email'))
            Text(
              contactInfo['email']!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 8.0),

          // Mostrar teléfono si está disponible
          if (contactInfo.containsKey('phone'))
            Text(
              'Tel: ${contactInfo['phone']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 16.0),

          // Iconos de redes sociales
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: socialLinks.map((link) {
              return IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  // Abrir el enlace de la red social
                  // Utiliza un paquete como `url_launcher` para abrir enlaces
                  print('Abriendo enlace: $link');
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

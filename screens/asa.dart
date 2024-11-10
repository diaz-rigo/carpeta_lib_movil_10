import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: 'YOUR_CLIENT_ID');

void _showLoginModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Row(
          children: [
            Image.network(
              'https://static.wixstatic.com/media/64de7c_4d76bd81efd44bb4a32757eadf78d898~mv2_d_1765_2028_s_2.png/v1/fill/w_234,h_270,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/64de7c_4d76bd81efd44bb4a32757eadf78d898~mv2_d_1765_2028_s_2.png',
              height: 40.0,
            ),
            const SizedBox(width: 10),
            const Text('Iniciar Sesión'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.pink[50], // Color suave de fondo
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.pink[50], // Color suave de fondo
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Iniciar sesión con Google"),
              onPressed: () async {
                try {
                  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
                  if (googleUser != null) {
                    // Realiza acciones con el usuario autenticado (como enviar token al backend)
                    print("Usuario autenticado: ${googleUser.displayName}");
                    Navigator.of(context).pop(); // Cerrar modal
                  }
                } catch (error) {
                  print("Error de autenticación: $error");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 248, 210, 187), // Color pastel suave
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para autenticar con email y contraseña
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 171, 119, 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Iniciar sesión'),
          ),
        ],
      );
    },
  );
}

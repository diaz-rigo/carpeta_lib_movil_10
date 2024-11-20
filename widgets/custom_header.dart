import 'package:austins/models/cart.dart';
import 'package:austins/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(String userId, String userName, String userEmail,
    String userPhotoUrl) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setString('userName', userName);
  await prefs.setString('userEmail', userEmail);
  await prefs.setString('userPhotoUrl', userPhotoUrl); // Guardar URL de la foto
}

Future<void> deleteUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
}

Future<bool> checkUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('userId');
}

Future<Map<String, String?>> getUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final userName = prefs.getString('userName');
  final userEmail = prefs.getString('userEmail');

  return {
    'userId': userId,
    'userName': userName,
    'userEmail': userEmail,
  };
}

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final bool isLoggedIn; // Agregar el parámetro isLoggedIn
  const CustomHeader({Key? key, required this.isLoggedIn})
      : super(key: key); // Modificar el constructor

  @override
  _CustomHeaderState createState() => _CustomHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(80.0);
}

class _CustomHeaderState extends State<CustomHeader> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ]);  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    isLoggedIn = await checkUserSession();
    setState(
        () {}); // Actualiza el estado para reflejar el ícono correspondiente
  }

  void _logoutUser() async {
    await _googleSignIn.signOut();
    await deleteUserSession();
    setState(() {
      isLoggedIn = false;
    });
  }

  void _navigateToProfile(BuildContext context) {
    // Aquí reemplaza `ProfileScreen` con el nombre de tu pantalla de perfil
    Navigator.pushNamed(context,
        '/profile'); // Asegúrate de que la ruta esté definida en tu MaterialApp
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 248, 210, 187),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://static.wixstatic.com/media/64de7c_29f387abde884a1e8f9df17220933df6~mv2.png/v1/fill/w_834,h_221,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/64de7c_29f387abde884a1e8f9df17220933df6~mv2.png',
            height: 40.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.brown[800]),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        tooltip: 'Menu',
      ),
      actions: [
        // Badge para el carrito de compras
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.brown[800]),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              tooltip: 'Cart',
            ),
            if (cart.itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        // Badge para favoritos
        Stack(
            // children: [
            //   IconButton(
            //     icon: Icon(Icons.favorite, color: Colors.brown[800]),
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/favorites');
            //     },
            //     tooltip: 'Favorites',
            //   ),
            //   Positioned(
            //     right: 8,
            //     top: 8,
            //     child: Container(
            //       padding: const EdgeInsets.all(2),
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       constraints: const BoxConstraints(
            //         minWidth: 16,
            //         minHeight: 16,
            //       ),
            //       child: const Text(
            //         '5',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 10,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // ],
            ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.brown[800]),
          onPressed: () {
            // Acción para la búsqueda
          },
          tooltip: 'Search',
        ),
        // Icono de perfil o login/logout según el estado
        IconButton(
          icon: userProvider.userPhotoUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(userProvider.userPhotoUrl!),
                  radius: 15,
                )
              : Icon(
                  widget.isLoggedIn ? Icons.person : Icons.login,
                  color: Colors.brown[800],
                ),
          onPressed: () {
            if (widget.isLoggedIn) {
              _navigateToProfile(
                  context); // Navega a la pantalla de perfil si está logueado
            } else {
              _showLoginModal(
                  context); // Muestra el modal de login si no está logueado
            }
          },
          tooltip: widget.isLoggedIn ? 'Ir a perfil' : 'Login',
        ),
      ],
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16.0),
        ),
      ),
    );
  }

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
                  fillColor: Colors.pink[50],
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
                  fillColor: Colors.pink[50],
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text("Iniciar sesión con Google"),
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleUser =
                        await _googleSignIn.signIn();
                    if (googleUser != null) {
                      String userPhotoUrl = googleUser.photoUrl ??
                          ''; // Si es null, usa una cadena vacía
                      // Imprimir en la consola los datos del usuario
                      print('-------------------------------${googleUser}');
                      print('User ID: ${googleUser.id}');
                      print('Display Name: ${googleUser.displayName}');
                      print('Email: ${googleUser.email}');
                      print('Photo URL: $userPhotoUrl');
                      print('Google User Details: ${googleUser.toString()}');

                      await saveUserSession(
                        googleUser.id,
                        googleUser.displayName ?? '',
                        googleUser.email,
                        userPhotoUrl, // Aquí se agrega la URL de la foto de perfil
                      );

                      // Actualizar el UserProvider con la información del usuario y su foto
                      Provider.of<UserProvider>(context, listen: false).setUser(
                        googleUser.id,
                        googleUser.displayName ?? '',
                        googleUser.email,
                        googleUser
                            .photoUrl, // Se agrega la URL de la foto de perfil
                      );
                      setState(() {
                        isLoggedIn = true;
                      });
                      Navigator.of(context).pop();
                    }
                  } catch (error) {
                    print("Error de autenticación: $error");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 237, 191, 161),
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
                backgroundColor: const Color.fromARGB(255, 248, 210, 187),
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
}

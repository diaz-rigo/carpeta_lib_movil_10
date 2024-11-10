import 'package:austins/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  // Map<String, dynamic>? product;

  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final bool isHighlighted;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isHighlighted ? 25.0 : 15.0),
        child: Stack(
          children: [
            Card(
              elevation: isHighlighted ? 20.0 : 8.0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(isHighlighted ? 30.0 : 20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(productId: id),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              isHighlighted ? 30.0 : 20.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            height: isHighlighted ? 280.0 : 260.0,
                            // AQUI AFECTA EL TAMAÑO

                            width: double.infinity,
                            // errorBuilder: (context, error, stackTrace) {
                            //   return const Center(
                            //     child: Icon(Icons.error, size: 50.0),
                            //   );
                            // },
                          ),
                        ),
                        if (isHighlighted)
                          Positioned(
                            top: 10.0,
                            right: 10.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Text(
                                'Producto Destacado',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          // AQUI TAMBIEN AFECTA ERROR TAMAÑO
                          style: TextStyle(
                            fontSize: isHighlighted ? 24.0 : 20.0,
                            // fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          '\$$price',
                          style: TextStyle(
                            fontSize: isHighlighted ? 22.0 : 18.0,
                            color: const Color.fromARGB(255, 255, 68, 0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: FloatingActionButton(
                onPressed: () {
                  final cart = Provider.of<Cart>(context, listen: false);
                  cart.addItem(
                    id,
                    title,
                    price,imageUrl
                  );

                  // Imprimir en consola el contenido del carrito
                  for (var item in cart.items) {
                    print(
                        'Producto: ${item.name}, Cantidad: ${item.quantity}, Precio: ${item.price}');
                  }
                  print('Total: ${cart.totalAmount}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto añadido al carrito!'),
                    ),
                  );

                  // Mostrar Bottom Sheet al hacer clic
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          bool _showComponent = true;

                          // Ocultar el componente automáticamente después de 3 segundos
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              _showComponent = false;
                            });
                            // Cerrar el Bottom Sheet después de que el componente se oculte
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context); // Cerrar el Bottom Sheet
                            });
                          });

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Ajusta el tamaño al contenido
                              children: [
                                Container(
                                  width: 60,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Producto agregado al carrito!',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                AnimatedOpacity(
                                  duration: const Duration(seconds: 1),
                                  opacity: _showComponent ? 1.0 : 0.0,
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    width: _showComponent
                                        ? 100
                                        : 0, // Ancho de la miniatura
                                    height: _showComponent
                                        ? 100
                                        : 0, // Alto de la miniatura
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _showComponent
                                            ? Colors.blueAccent
                                            : const Color.fromARGB(0, 245, 63,
                                                63), // Cambia el color del borde
                                        width: _showComponent
                                            ? 2
                                            : 0, // Cambia el grosor del borde
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          10), // Redondeo en los bordes
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10), // Redondeo de la imagen también
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit
                                            .cover, // Ajuste de la imagen para cubrir el contenedor
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (_showComponent) ...[
                                  Text(
                                    '${title} - Cantidad: 1',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 255, 40, 40)),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Total: \$${(price * 1).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 243, 116, 11)),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.add_shopping_cart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

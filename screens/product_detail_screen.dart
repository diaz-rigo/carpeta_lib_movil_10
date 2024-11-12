import 'package:austins/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  int quantity = 1;
  int currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    _pageController = PageController();
  }

  Future<void> fetchProductDetails() async {
    final url =
        Uri.parse('https://austin-b.onrender.com/product/${widget.productId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        product = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
        backgroundColor: const Color.fromARGB(255, 248, 210, 187),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              // Mostrar la cantidad de ítems si es mayor a 0
              if (cart.itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
              ? const Center(child: Text("No se pudo cargar el producto"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product!['name'],
                                style: const TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A4A4A),
                                ),
                              ),
                              const SizedBox(height: 12.0),

                              // Carrusel de imágenes
                              SizedBox(
                                height: 250,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: product!['images'].length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentImageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        product!['images'][index],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Barra de miniaturas
                              const SizedBox(height: 12.0),
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: product!['images'].length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentImageIndex = index;
                                          _pageController.jumpToPage(index);
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: currentImageIndex == index
                                                ? Colors.blue
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            product!['images'][index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 70,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16.0),
                              const Text(
                                'Descripción:',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                product!['description'],
                                style: const TextStyle(
                                    fontSize: 16.0, color: Color(0xFF4A4A4A)),
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Precio unitario: \$${product!['price']}',
                                    style: const TextStyle(
                                        fontSize: 22.0, color: Colors.green),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      // Acción para añadir a favoritos
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cantidad:',
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        onPressed: _decreaseQuantity,
                                      ),
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        onPressed: _increaseQuantity,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),

                              Text(
                                'Total: \$${((product!['price'] as num).toDouble() * quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 243, 116, 11),
                                ),
                              ),

                              const SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final cart =
                                Provider.of<Cart>(context, listen: false);
                            cart.addItem(
                              product?['_id'] ?? '',
                              // product!['id'],
                              product?['name'] ?? 'Producto sin nombre',
                              (product?['price'] ?? 0.0)
                                  .toDouble(), // Convertir a double
                              product!['images'][0],
                            );

// Imprimir en consola el contenido completo del carrito
                            for (var item in cart.items) {
                              print('ID: ${item.id}, '
                                  'Producto: ${item.name}, '
                                  'Cantidad: ${item.quantity}, '
                                  'Precio: ${item.price}, '
                                  'Imagen: ${item.imageUrl}');
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0)),
                              ),
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    bool _showComponent = true;

                                    // Ocultar el componente automáticamente después de 3 segundos
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      if (mounted) {
                                        // Verificación si el widget sigue montado
                                        setState(() {
                                          _showComponent = false;
                                        });
                                      }
                                      // Cerrar el Bottom Sheet después de que el componente se oculte
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        if (mounted) {
                                          Navigator.pop(
                                              context); // Cerrar el Bottom Sheet
                                        }
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
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
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
                                            duration:
                                                const Duration(seconds: 1),
                                            opacity: _showComponent ? 1.0 : 0.0,
                                            child: AnimatedContainer(
                                              duration:
                                                  const Duration(seconds: 1),
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
                                                      : const Color.fromARGB(
                                                          0,
                                                          245,
                                                          63,
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
                                                  product!['images'][0],
                                                  fit: BoxFit
                                                      .cover, // Ajuste de la imagen para cubrir el contenedor
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          if (_showComponent) ...[
                                            Text(
                                              '${product!['name']} - Cantidad: $quantity',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 255, 40, 40)),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Total: \$${(product!['price'] * quantity).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 243, 116, 11)),
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
                          icon: const Icon(Icons.add_shopping_cart, size: 24),
                          label: const Text('Agregar al Carrito',
                              style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            iconColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

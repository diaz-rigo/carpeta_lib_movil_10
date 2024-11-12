import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para serializar y deserializar datos

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // Campo de imagen
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    if (!isValidImageUrl) {
      throw Exception("URL de imagen no válida: $imageUrl");
    }
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  // Validar si la URL de la imagen es válida
  bool get isValidImageUrl {
    try {
      final uri = Uri.parse(imageUrl);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  Set<String> _addingItems =
      {}; // Set para verificar los elementos que se están añadiendo

  List<CartItem> get items => _items;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> addItem(
      String productId, String name, double price, String imageUrl) async {
    // Prevenir adiciones múltiples del mismo producto en paralelo
    if (_addingItems.contains(productId)) {
      print("El producto $name ya se está añadiendo. Espera un momento.");
      return;
    }

    // Marca el producto como "en proceso de añadir"
    _addingItems.add(productId);

    final existingIndex = _items.indexWhere((item) => item.id == productId);

    if (existingIndex >= 0) {
      print("Producto ya existe en el carrito. Incrementando cantidad...");
      _items[existingIndex].quantity++;
    } else {
      print("Producto nuevo. Añadiendo al carrito...");
      _items.add(
        CartItem(
          id: productId,
          name: name,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }

    saveCartToPreferences(); // Guarda el carrito después de cada cambio
    notifyListeners();

    // Remueve el producto del set después de añadirlo
    _addingItems.remove(productId);
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    saveCartToPreferences();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    saveCartToPreferences();
    notifyListeners();
  }

  Future<void> loadCartFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');

    if (cartData != null) {
      List<dynamic> decodedData = jsonDecode(cartData);
      _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCartToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cartData =
        _items.map((item) => item.toJson()).toList();
    prefs.setString('cart', jsonEncode(cartData));
  }
}

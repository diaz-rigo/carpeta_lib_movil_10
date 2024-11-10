import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para serializar y deserializar datos

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // Agregar el campo de imagen
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl, // Incluir el nuevo parámetro en el constructor
    this.quantity = 1,
  });

  // Método para convertir el objeto a un Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl, // Incluir la imagen en el JSON
      'quantity': quantity,
    };
  }

  // Método para crear un CartItem a partir de un Map
  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'], // Leer la imagen del JSON
      quantity: json['quantity'],
    );
  }
}


class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

 // Getter para obtener el total de ítems en el carrito
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

void addItem(String productId, String name, double price, String imageUrl) {
  final existingIndex = _items.indexWhere((item) => item.id == productId);
  if (existingIndex >= 0) {
    _items[existingIndex].quantity++;
  } else {
    _items.add(CartItem(id: productId, name: name, price: price, imageUrl: imageUrl)); // Incluir la imagen
  }
  saveCartToPreferences(); // Guardar al agregar un producto
  notifyListeners();
}


  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    saveCartToPreferences(); // Guardar al eliminar un producto
    notifyListeners();
  }

  void clear() {
    _items.clear();
    saveCartToPreferences(); // Guardar al vaciar el carrito
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
    List<Map<String, dynamic>> cartData = _items.map((item) => item.toJson()).toList();
    prefs.setString('cart', jsonEncode(cartData));
  }
}

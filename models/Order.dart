import 'dart:convert';

// Modelo para los datos del cliente
class CustomerData {
  final String name;
  final String paternalLastname;
  final String maternalLastname;
  final String email;
  final String phone;

  CustomerData({
    required this.name,
    required this.paternalLastname,
    required this.maternalLastname,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'paternalLastname': paternalLastname,
      'maternalLastname': maternalLastname,
      'email': email,
      'phone': phone,
    };
  }
}

// Modelo de la orden del carrito para Stripe
class Order {
  final double totalNetAmount;      // Total neto de la orden
  final String deliveryType;        // Tipo de entrega (por ejemplo, 'domicilio', 'en tienda')
  final String deliveryDate;        // Fecha de entrega seleccionada
  final String instruction;         // Instrucciones especiales para la entrega
  final CustomerData customerData;  // Datos del cliente
  final List<CartItem> items;       // Lista de artículos del carrito

  Order({
    required this.totalNetAmount,
    required this.deliveryType,
    required this.deliveryDate,
    required this.instruction,
    required this.customerData,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalNetAmount': totalNetAmount,
      'deliveryType': deliveryType,
      'deliveryDate': deliveryDate,
      'instruction': instruction,
      'customerData': customerData.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

// Supongamos que CartItem ya está definido como en tu ejemplo original
class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}

class Product {
  final String id;
  final String sku;
  final String name;
  final String description;
  final double price;
  final List<String> images;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
    );
  }
}

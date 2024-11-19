class Purchase {
  final String id;
  final String date;
  final List<Map<String, dynamic>> products;
  final double total;

  Purchase({
    required this.id,
    required this.date,
    required this.products,
    required this.total,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['_id'],
      date: json['date'],
      products: List<Map<String, dynamic>>.from(json['products']),
      total: json['total'],
    );
  }
}

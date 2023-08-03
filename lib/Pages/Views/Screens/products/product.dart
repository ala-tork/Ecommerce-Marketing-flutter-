class Product {
  final int id;
  final double price;
  final String? title;
  final String? codeBar;
  final String? description;
  final String? details;
  final String? color;
  final DateTime datePublication;
  final int qty;
  final String? imageBase64;
  final String? videoBase64;

  Product({
    required this.id,
    required this.price,
    required this.imageBase64,
    required this.videoBase64,
    this.title,
    this.codeBar,
    this.color,
    this.description,
    this.details,
    required this.datePublication,
    required this.qty,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price'].toDouble(),
      imageBase64: json['imageBase64'],
      videoBase64: json['videoBase64'],
      description: json['description'],
      details: json['details'],
      title: json['title'],
      codeBar: json['codeBar'],
      color: json['color'],
      qty: json['qty'],
      datePublication: DateTime.parse(json['datePublication']),
    );
  }
}

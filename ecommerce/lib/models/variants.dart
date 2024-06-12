class Variants {
  final String? name;
  final int? price;
  final int? stock;
  final String? imageUrl;

  Variants(
      {required this.name,
      required this.price,
      required this.stock,
      required this.imageUrl});

  factory Variants.fromJson(Map<String, dynamic> json) {
    return Variants(
        name: json['name'],
        price: json['price'],
        stock: json['stock'],
        imageUrl: json['imageUrl']);
  }
}

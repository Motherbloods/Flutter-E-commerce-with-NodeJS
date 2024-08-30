class Variants {
  final String? id;
  final String? name;
  final int? price;
  final int? stock;
  final String? imageUrl;
  final String? sellerName;

  Variants(
      {required this.id,
      required this.name,
      required this.price,
      required this.stock,
      required this.imageUrl,
      required this.sellerName});

  factory Variants.fromJson(Map<String, dynamic> json) {
    return Variants(
        id: json['_id'],
        name: json['name'],
        price: json['price'],
        stock: json['stock'],
        imageUrl: json['imageUrl'],
        sellerName: json['sellerName']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'sellerName': sellerName
    };
  }
}

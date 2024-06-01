class Product {
  final String? id;
  final String? name;
  final String? sellerId;
  final int? price;
  final List<String>? category;
  final int? stockQuantity;
  final int? salesLastWeek;
  final int? totalUnitsSold;
  final String? sellerName;
  final String? imageUrl;

  Product(
      {this.id,
      this.name,
      this.sellerId,
      this.price,
      this.category,
      this.stockQuantity,
      this.salesLastWeek,
      this.totalUnitsSold,
      this.sellerName,
      this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      sellerId: json['sellerId'],
      price: json['price'],
      category:
          (json['category'] as List<dynamic>).map((e) => e as String).toList(),
      stockQuantity: json['stockQuantity'],
      totalUnitsSold: json['totalUnitsSold'],
      salesLastWeek: json['salesLastWeek'],
      sellerName: json['sellerName'],
      imageUrl: json['imageUrl'],
    );
  }
}

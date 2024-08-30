import 'package:ecommerce/models/ulasan.dart';
import 'package:ecommerce/models/variants.dart';

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
  final List<Ulasan>? reviews;
  final List<Variants>? variants;

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
      this.reviews,
      this.variants,
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
      reviews: json['reviews'] != null
          ? (json['reviews'] as List<dynamic>)
              .map((reviewJson) =>
                  Ulasan.fromJson(reviewJson as Map<String, dynamic>))
              .toList()
          : null,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((variantJson) =>
              Variants.fromJson(variantJson as Map<String, dynamic>))
          .toList(),
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      sellerId: map['sellerId'],
      category:
          (map['category'] as List<dynamic>).map((e) => e as String).toList(),
      stockQuantity: map['stockQuantity'],
      totalUnitsSold: map['totalUnitsSold'],
      salesLastWeek: map['salesLastWeek'],
      sellerName: map['sellerName'],
      imageUrl: map['imageUrl'],
      reviews: map['reviews'] != null
          ? (map['reviews'] as List<dynamic>)
              .map((reviewmap) =>
                  Ulasan.fromJson(reviewmap as Map<String, dynamic>))
              .toList()
          : null,
      variants: (map['variants'] as List<dynamic>?)
          ?.map((variantJson) =>
              Variants.fromJson(variantJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

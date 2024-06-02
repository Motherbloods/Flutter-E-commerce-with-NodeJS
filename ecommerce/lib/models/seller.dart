class Seller {
  final String? id;
  final String? namaToko;
  final String? email;
  final int? noHP;
  final List<String>? kategoriPenjualanBrg;
  final String? alamatToko;
  final int? totalProductSalesLastWeek;
  final int? totalUnitsSold;

  Seller({
    this.id,
    this.namaToko,
    this.email,
    this.noHP,
    this.alamatToko,
    this.totalProductSalesLastWeek,
    this.totalUnitsSold,
    this.kategoriPenjualanBrg,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['_id'],
      namaToko: json['namaToko'],
      email: json['email'],
      noHP: json['noHP'],
      kategoriPenjualanBrg: (json['kategoriPenjualanBrg'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      alamatToko: json['alamatToko'],
      totalProductSalesLastWeek: json['totalProductSalesLastWeek'],
      totalUnitsSold: json['totalUnitsSold'],
    );
  }
}

class Seller {
  final String? id;
  final String? namaToko;
  final String? fullName;
  final String? email;
  final int? noHP;
  final List<String>? kategoriPenjualanBrg;
  final String? alamatToko;
  final int? totalProductSalesLastWeek;
  final int? totalUnitsSold;

  Seller({
    this.id,
    this.fullName,
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
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      namaToko: json['namaToko'] as String?,
      email: json['email'] as String?,
      noHP: json['noHP'] != null ? int.tryParse(json['noHP'].toString()) : null,
      kategoriPenjualanBrg: json['kategoriPenjualanBrg'] != null
          ? (json['kategoriPenjualanBrg'] as List<dynamic>).cast<String>()
          : null,
      alamatToko: json['alamatToko'] as String?,
      totalProductSalesLastWeek: json['totalProductSalesLastWeek'] as int?,
      totalUnitsSold: json['totalUnitsSold'] as int?,
    );
  }
}

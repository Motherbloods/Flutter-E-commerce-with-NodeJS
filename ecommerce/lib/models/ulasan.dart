class Ulasan {
  final String? id;
  final String? userId;
  final String? productId;
  final String? review;
  final DateTime? date;
  final List<String>? picture;

  Ulasan({
    this.id,
    this.userId,
    this.productId,
    this.review,
    this.date,
    this.picture,
  });

  factory Ulasan.fromJson(Map<String, dynamic> json) {
    List<String>? pictureList = [];
    if (json['picture'] != null) {
      pictureList = List<String>.from(json['picture']);
    }

    return Ulasan(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      productId: json['productId'] as String?,
      review: json['review'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      picture: pictureList,
    );
  }
}

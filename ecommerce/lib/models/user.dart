class User {
  final String? id;
  final String? email;
  final String? fullName;
  final String? img;
  final String? namaToko;
  final int? noHP;

  User({
    this.id,
    this.email,
    this.fullName,
    this.img,
    this.namaToko,
    this.noHP,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      fullName: json['fullName'],
      img: json['img'],
      namaToko: json['namaToko'],
      noHP: json['noHP'],
    );
  }
}

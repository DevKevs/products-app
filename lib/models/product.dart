// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

class Product {
  Product({
    required this.avalible,
    required this.name,
    this.picture,
    required this.price,
    this.id,
  });

  bool avalible;
  String name;
  String? picture;
  double price;
  String? id;

  String get productImage {
    if (picture != null && picture != '') {
      return picture!;
    }
    return 'https://consultix.radiantthemes.com/demo-nine/wp-content/themes/consultix/images/no-image-found-360x250.png';
  }

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        avalible: json["avalible"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "avalible": avalible,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Product copy() => Product(
        avalible: avalible,
        name: name,
        price: price,
        picture: productImage,
        id: id,
      );
}

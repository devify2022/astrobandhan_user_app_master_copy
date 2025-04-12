// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? id;
  String? productName;
  String? image;
  String? productDescription;
  String? category;
  int? rating;
  String? brand;
  String? weight;
  String? material;
  int? originalPrice;
  int? displayPrice;
  bool? inStock;
  bool? isTrending;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ProductModel({
    this.id,
    this.productName,
    this.image,
    this.productDescription,
    this.category,
    this.rating,
    this.brand,
    this.weight,
    this.material,
    this.originalPrice,
    this.displayPrice,
    this.inStock,
    this.isTrending,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        productName: json["productName"],
        image: json["image"],
        productDescription: json["productDescription"],
        category: json["category"],
        rating: json["rating"],
        brand: json["brand"],
        weight: json["weight"],
        material: json["material"],
        originalPrice: json["originalPrice"],
        displayPrice: json["displayPrice"],
        inStock: json["in_stock"],
        isTrending: json["isTrending"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productName": productName,
        "image": image,
        "productDescription": productDescription,
        "category": category,
        "rating": rating,
        "brand": brand,
        "weight": weight,
        "material": material,
        "originalPrice": originalPrice,
        "displayPrice": displayPrice,
        "in_stock": inStock,
        "isTrending": isTrending,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

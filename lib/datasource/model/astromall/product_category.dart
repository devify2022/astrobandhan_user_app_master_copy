// To parse this JSON data, do
//
//     final productCategoryModel = productCategoryModelFromJson(jsonString);

import 'dart:convert';

ProductCategoryModel productCategoryModelFromJson(String str) =>
    ProductCategoryModel.fromJson(json.decode(str));

String productCategoryModelToJson(ProductCategoryModel data) =>
    json.encode(data.toJson());

class ProductCategoryModel {
  String? id;
  String? categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? imageUrl;
  int? totalItems;

  ProductCategoryModel({
    this.id,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.imageUrl,
    this.totalItems,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel(
        id: json["_id"],
        categoryName: json["category_name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        imageUrl: json["imageUrl"],
        totalItems: json["totalItems"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_name": categoryName,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "imageUrl": imageUrl,
        "totalItems": totalItems,
      };
}

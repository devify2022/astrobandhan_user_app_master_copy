// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? email;
  DateTime? dateOfBirth;
  String? password;
  String? timeOfBirth;
  String? placeOfBirth;
  String? gender;
  String? phone;
  double? walletBalance;
  bool? freeChatAvailable;
  List<dynamic>? followedAstrologers;
  List<dynamic>? consultations;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? photo;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.dateOfBirth,
    this.password,
    this.timeOfBirth,
    this.placeOfBirth,
    this.gender,
    this.phone,
    this.walletBalance,
    this.freeChatAvailable,
    this.followedAstrologers,
    this.consultations,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
        password: json["password"],
        timeOfBirth: json["timeOfBirth"],
        placeOfBirth: json["placeOfBirth"],
        gender: json["gender"],
        phone: json["phone"],
        walletBalance: json["walletBalance"]?.toDouble(),
        freeChatAvailable: json["Free_Chat_Available"],
        followedAstrologers: json["followed_astrologers"] == null ? [] : List<dynamic>.from(json["followed_astrologers"]!.map((x) => x)),
        consultations: json["consultations"] == null ? [] : List<dynamic>.from(json["consultations"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "dateOfBirth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "password": password,
        "timeOfBirth": timeOfBirth,
        "placeOfBirth": placeOfBirth,
        "gender": gender,
        "phone": phone,
        "walletBalance": walletBalance,
        "Free_Chat_Available": freeChatAvailable,
        "followed_astrologers": followedAstrologers == null ? [] : List<dynamic>.from(followedAstrologers!.map((x) => x)),
        "consultations": consultations == null ? [] : List<dynamic>.from(consultations!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "photo": photo,
      };
}

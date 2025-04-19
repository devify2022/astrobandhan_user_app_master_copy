class LoginUserModel {
  LoginUserModel({
    this.id,
    this.name,
    this.phone,
    this.freeChatAvailable,
    this.wallet, // Add wallet as a parameter in the constructor
  });

  LoginUserModel.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    phone = json['phone'];
    freeChatAvailable = json['Free_Chat_Available'];
    wallet =
        json['walletBalance']; // Correct the typo and make sure it's dynamic
  }

  String? id;
  String? name;
  String? phone;
  bool? freeChatAvailable;
  num? wallet; 

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id; // Use _id here to match the response format
    map['name'] = name;
    map['phone'] = phone;
    map['Free_Chat_Available'] = freeChatAvailable;
    map['walletBalance'] = wallet; // Add wallet to the toJson method
    return map;
  }
}

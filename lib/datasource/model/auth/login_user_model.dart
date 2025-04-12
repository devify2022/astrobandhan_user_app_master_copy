class LoginUserModel {
  LoginUserModel({
    this.id,
    this.name,
    this.phone,
    this.freeChatAvailable,
  });

  LoginUserModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    freeChatAvailable = json['Free_Chat_Available'];
  }

  String? id;
  String? name;
  String? phone;
  bool? freeChatAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['Free_Chat_Available'] = freeChatAvailable;
    return map;
  }
}

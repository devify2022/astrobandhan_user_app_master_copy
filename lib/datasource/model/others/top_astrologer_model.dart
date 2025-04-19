class TopAstrologerModel {
  final String id;
  final String name;
  final String status;  
  final String avatar;
 

  TopAstrologerModel({
    required this.id,
    required this.name,
    required this.status,
    required this.avatar,
    
  });

  factory TopAstrologerModel.fromJson(Map<String, dynamic> json) {
    return TopAstrologerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
     avatar: json['avatar'] ?? '',
    );
  }
}

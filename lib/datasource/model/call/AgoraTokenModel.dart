class AgoraTokenModel {
  final String token;

  AgoraTokenModel({required this.token});

  factory AgoraTokenModel.fromJson(Map<String, dynamic> json) {
    // Check for null values and handle them safely
    if (json['data'] != null && json['data']['token'] != null) {
      return AgoraTokenModel(token: json['data']['token']);
    } else {
      throw Exception('Token is missing in the response');
    }
  }
}

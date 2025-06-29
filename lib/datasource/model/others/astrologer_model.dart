class AstrologerModel {
  final String id;
  final String name;
  final int experience;
  final double rating;
  final List<String> specialities;
  final String avatar;
  final double pricePerCallMinute;
  final double pricePerVideoCallMinute;
  final double pricePerChatMinute;
  final String status;

  /// The `available` object
  final bool isAvailable;
  final bool isCallAvailable;
  final bool isChatAvailable;
  final bool isVideoCallAvailable;

  final bool isVerified;
  final bool isFeatured;
  final String gender;
  final String phone;
  final int walletBalance;
  final int chatCommission;
  final int callCommission;
  final int videoCallCommission;

  /// For "isOffline" or "isOnline" flags
  final bool isOffline;

  /// New field: popular
  final bool popular;

  /// Reviews list
  final List<ReviewModel> reviews;

  AstrologerModel({
    required this.id,
    required this.name,
    required this.experience,
    required this.specialities,
    required this.rating,
    required this.avatar,
    required this.pricePerCallMinute,
    required this.pricePerVideoCallMinute,
    required this.pricePerChatMinute,
    required this.isAvailable,
    required this.isCallAvailable,
    required this.isChatAvailable,
    required this.isVideoCallAvailable,
    required this.isVerified,
    required this.isFeatured,
    required this.gender,
    required this.phone,
    required this.walletBalance,
    required this.chatCommission,
    required this.callCommission,
    required this.videoCallCommission,
    required this.isOffline,
    required this.popular,
    required this.status,
    required this.reviews, // Added reviews field
  });

  factory AstrologerModel.fromJson(Map<String, dynamic> json) {
    final available = json['available'] ?? {};
    final reviewsList = (json['reviews'] ?? [])
        .map<ReviewModel>((review) => ReviewModel.fromJson(review))
        .toList();

    return AstrologerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      experience: json['experience'] ?? 0,
     rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) ?? 0.0 : 0.0,
      specialities: List<String>.from(json['specialities'] ?? []),
      avatar: json['avatar'] ?? '',
      pricePerCallMinute: (json['pricePerCallMinute'] ?? 0).toDouble(),
      pricePerVideoCallMinute:
          (json['pricePerVideoCallMinute'] ?? 0).toDouble(),
      pricePerChatMinute: (json['pricePerChatMinute'] ?? 0).toDouble(),
      isAvailable: available['isAvailable'] ?? false,
      isCallAvailable: available['isCallAvailable'] ?? false,
      isChatAvailable: available['isChatAvailable'] ?? false,
      isVideoCallAvailable: available['isVideoCallAvailable'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      walletBalance: json['walletBalance'] ?? 0,
      chatCommission: json['chatCommission'] ?? 0,
      callCommission: json['callCommission'] ?? 0,
      videoCallCommission: json['videoCallCommission'] ?? 0,
      isOffline: json['isOffline'] ?? false,
      popular: json['popular'] ?? false,
      reviews: reviewsList, // Added reviews parsing
    );
  }
}

class ReviewModel {
  final String comment;
  final int rating;
  final String userName;

  ReviewModel({
    required this.comment,
    required this.rating,
    required this.userName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      userName: json['userName'] ?? 'Anonymous',
    );
  }
}

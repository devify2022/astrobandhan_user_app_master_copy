class AstrologerModel {
  final String id;
  final String name;
  final int experience;
  final int rating;
  final List<String> specialities;
  final String avatar;
  final double pricePerCallMinute;
  final double pricePerVideoCallMinute;
  final double pricePerChatMinute;

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
    required this.popular, // Add the new field here
  });

  factory AstrologerModel.fromJson(Map<String, dynamic> json) {
    // The "available" sub-object might be null if not present
    final available = json['available'] ?? {};

    return AstrologerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      experience: json['experience'] ?? 0,
      rating: json['rating'] ?? 0,
      specialities: List<String>.from(json['specialities'] ?? []),
      avatar: json['avatar'] ?? '',
      pricePerCallMinute: (json['pricePerCallMinute'] ?? 0).toDouble(),
      pricePerVideoCallMinute: (json['pricePerVideoCallMinute'] ?? 0).toDouble(),
      pricePerChatMinute: (json['pricePerChatMinute'] ?? 0).toDouble(),

      // available object
      isAvailable: available['isAvailable'] ?? false,
      isCallAvailable: available['isCallAvailable'] ?? false,
      isChatAvailable: available['isChatAvailable'] ?? false,
      isVideoCallAvailable: available['isVideoCallAvailable'] ?? false,

      // other booleans / fields
      isVerified: json['isVerified'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      walletBalance: json['walletBalance'] ?? 0,
      chatCommission: json['chatCommission'] ?? 0,
      callCommission: json['callCommission'] ?? 0,
      videoCallCommission: json['videoCallCommission'] ?? 0,
      isOffline: json['isOffline'] ?? false,

      // New field: popular
      popular: json['popular'] ?? false, // Default to false if not present
    );
  }
}

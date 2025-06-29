class ChatRoomModel {
  final String chatRoomId;
  final String chatType;
  final String status;
  final CreatedAt createdAt;
  final UpdatedAt updatedAt;
  final User user;
  final Astrologer astrologer;

  ChatRoomModel({
    required this.chatRoomId,
    required this.chatType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.astrologer,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatRoomId: json['chatRoomId'],
      chatType: json['chatType'],
      status: json['status'],
      createdAt: CreatedAt.fromJson(json['createdAt']),
      updatedAt: UpdatedAt.fromJson(json['updatedAt']),
      user: User.fromJson(json['user']),
      astrologer: Astrologer.fromJson(json['astrologer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'chatType': chatType,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'user': user.toJson(),
      'astrologer': astrologer.toJson(),
    };
  }

  // 🔥 ADD THIS
  ChatRoomModel copyWith({
    String? chatRoomId,
    String? chatType,
    String? status,
    CreatedAt? createdAt,
    UpdatedAt? updatedAt,
    User? user,
    Astrologer? astrologer,
  }) {
    return ChatRoomModel(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      chatType: chatType ?? this.chatType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      astrologer: astrologer ?? this.astrologer,
    );
  }
}

class UpdatedAt {
  final String date;
  final String time;

  UpdatedAt({required this.date, required this.time});

  factory UpdatedAt.fromJson(Map<String, dynamic> json) {
    return UpdatedAt(
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
    };
  }
}

class CreatedAt {
  final String date;
  final String time;

  CreatedAt({required this.date, required this.time});

  factory CreatedAt.fromJson(Map<String, dynamic> json) {
    return CreatedAt(
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
    };
  }
}

class User {
  final String name;
  final String id;

  User({required this.name, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, '_id': id};
  }
}

class Astrologer {
  final String id;
  final String name;
  final String avatar;
  final num consultation_rate;

  Astrologer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.consultation_rate,
  });

  factory Astrologer.fromJson(Map<String, dynamic> json) {
    return Astrologer(
      id: json['_id'],
      name: json['name'],
      avatar: json['avatar'],
      consultation_rate: json['consultation_rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'avatar': avatar,
      'Consultation_rate': consultation_rate,
    };
  }
}

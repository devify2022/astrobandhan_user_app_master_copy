import 'dart:convert';

class UserOrder {
  final String userId;
  final String name;
  final String email;
  final String city;
  final String state;
  final String phone;
  final String address;
  final String productId;
  final DateTime deliveryDate;
  final int quantity;
  final double totalPrice;

  UserOrder({
    required this.userId,
    required this.name,
    required this.email,
    required this.city,
    required this.state,
    required this.phone,
    required this.address,
    required this.productId,
    required this.deliveryDate,
    required this.quantity,
    required this.totalPrice,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      city: json['city'],
      state: json['state'],
      phone: json['phone'],
      address: json['address'],
      productId: json['order_details'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      quantity: json['quantity'],
      totalPrice: json['total_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'city': city,
      'state': state,
      'phone': phone,
      'address': address,
      'order_details': productId,
      'delivery_date': deliveryDate.toIso8601String(),
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

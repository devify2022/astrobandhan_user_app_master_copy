class GiftModel {
  final String name;
  final String imagePath;
  final int price;

  GiftModel({
    required this.name,
    required this.imagePath,
    required this.price,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'price': price,
    };
  }
}

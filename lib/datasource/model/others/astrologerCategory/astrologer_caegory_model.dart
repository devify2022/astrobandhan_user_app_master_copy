class AstrologerCategory {
  final String name;

  AstrologerCategory({required this.name});

  factory AstrologerCategory.fromJson(Map<String, dynamic> json) {
    return AstrologerCategory(
      name: json['name'] ?? 'Unnamed Category', // Fallback if null
    );
  }
}

class CategoryResponse {
  final List<AstrologerCategory> categories;
  final String message;

  CategoryResponse({
    required this.categories,
    required this.message,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      categories: (json['data'] as List)
          .map((category) => AstrologerCategory.fromJson(category))
          .toList(),
      message: json['message'] ?? 'No message',
    );
  }
}

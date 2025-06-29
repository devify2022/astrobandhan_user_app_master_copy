class AstrologerCategory {
  final String id;
  final String name;
  final List<String> astrologers; // Store astrologer IDs if needed

  AstrologerCategory({
    required this.id,
    required this.name,
    required this.astrologers,
  });

  factory AstrologerCategory.fromJson(Map<String, dynamic> json) {
    return AstrologerCategory(
      id: json['_id'] ?? '', // Handle potential null
      name: json['name'] ?? 'Unnamed Category',
      astrologers: List<String>.from(
          json['astrologers'] ?? []), // Convert astrologer IDs
    );
  }
}

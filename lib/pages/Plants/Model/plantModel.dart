class Plant {
  final String id;
  final String name;
  final String description;
  final String image;
  final DateTime createdAt;
  String? type; // Add this field

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    this.type, // Add this field
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      // type: json['type'], // Add this field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      // 'type': type, // Do not save this field
    };
  }
}

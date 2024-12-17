class Plant {
  final String id;
  final String name;
  final String description;
  final String image;
   DateTime addedDate;
   String type; // Add this field

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.addedDate,
    required this.type, // Add this field
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      addedDate: DateTime.parse(json['addedDate']),
      type: json['type'], // Add this field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'addedDate': addedDate.toIso8601String(),
      'type': type, // Add this field
    };
  }
}
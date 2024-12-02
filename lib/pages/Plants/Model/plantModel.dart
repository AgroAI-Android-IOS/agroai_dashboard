class Plant {
  final String id;
  final String name;
  final String description;
  final String image;

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}
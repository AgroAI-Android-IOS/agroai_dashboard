class User {
  final String? id;
  final String name;
  final String email;
  final String? role;
  final String? phone;
  final String password;

  User(
      {this.id,
      required this.name,
      required this.email,
      this.role,
      this.phone,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'password': password,
    };
  }
}

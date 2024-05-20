enum UserType {
  seller,
  client,
}

class User {
  String id;
  String email;
  String username;
  String? image;
  UserType userType;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.image,
    required this.userType,
  });
  // Convert User object to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'image': image,
      'userType': userType.toString().split('.').last, // Convert enum to string
    };
  }

  // Create User object from a map (for JSON deserialization)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'] ?? "None",
      image: json['image'],
      userType: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_type'],
      ),
    );
  }
}

enum UserType {
  seller,
  client,
}

class User {
  String email;
  String username;
  String image;
  UserType userType;

  User({
    required this.email,
    required this.username,
    required this.image,
    required this.userType,
  });
  // Convert User object to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'image': image,
      'userType': userType.toString().split('.').last, // Convert enum to string
    };
  }

  // Create User object from a map (for JSON deserialization)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      image: json['image'],
      userType: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['userType'],
      ),
    );
  }
}

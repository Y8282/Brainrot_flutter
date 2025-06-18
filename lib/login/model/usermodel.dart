class UserModel {
  final String username;
  final String email;
  final String? profile_image;

  UserModel({
    required this.username,
    required this.email,
    this.profile_image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profile_image: json['profile_image'] ?? '',
    );
  }
}
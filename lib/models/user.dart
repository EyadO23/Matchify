class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? profilePictureUrl;
  final String apiToken;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.apiToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profilePictureUrl:
          json['profile_picture_url'] != null
              ? json['profile_picture_url'] as String
              : null,
      apiToken: json['api_token'] as String,
    );
  }

  Map<String, dynamic> toJsonForRegister(
    String password,
    String confirmPassword,
  ) {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'api_token': apiToken,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, username: $username, email: $email, token: $apiToken)';
  }
}

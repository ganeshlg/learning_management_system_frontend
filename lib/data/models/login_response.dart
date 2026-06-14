class LoginResponse {
  static const String successMessage = 'Login successful';

  final String message;
  final User? user;

  LoginResponse({
    required this.message,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      user: json['message'] == successMessage && json['user'] != null
          ? User.fromJson(json['user'])
          : null,
    );
  }

  bool get isSuccess => message == successMessage;
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
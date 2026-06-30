class LoginResponse {
  static const String successMessage = 'Login successful';

  final String message;
  final User? user;

  LoginResponse({
    required this.message,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // If the "user" key exists, parse it.
    if (json.containsKey('user') && json['user'] != null) {
      return LoginResponse(
        message: json['message'] ?? '',
        user: User.fromJson(json['user']),
      );
    } 
    
    // If "email" exists at the root, the root object might be the user.
    if (json.containsKey('email') && json['email'] != null) {
      return LoginResponse(
        message: json['message'] ?? '',
        user: User.fromJson(json),
      );
    }

    return LoginResponse(
      message: json['message'] ?? '',
      user: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': user?.toJson(),
      };

  bool get isSuccess => user != null;
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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}

class RegistrationResponse {
  static const String successMessage = 'User registered';

  final String message;

  RegistrationResponse({
    required this.message,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      message: json['message'] ?? '',
    );
  }

  bool get isSuccess => message == successMessage;
}
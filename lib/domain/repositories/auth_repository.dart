import 'package:learning_management_system_student/data/models/login_response.dart';
import 'package:learning_management_system_student/data/models/register_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> getCurrentUser();
  Future<LoginResponse> login(String userId, String password);
  Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendOtp(String email);
  Future<bool> verifyOtp(String email, String otp);
  Future<void> resetPassword(String email, String newPassword);
}

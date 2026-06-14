import 'package:learning_management_system_student/data/models/register_response.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/login_response.dart';

class MockAuthRepository implements AuthRepository {
  LoginResponse? _loginResponse;

  @override
  Future<LoginResponse?> getCurrentUser() async {
    return _loginResponse;
  }

  @override
  Future<LoginResponse> login(String userId, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _loginResponse = LoginResponse(message: 'Login successful', user: User(id: 1, name: 'John Doe', email: userId));
    return _loginResponse!;
  }

  @override
  Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return RegistrationResponse(message: 'Registration successful');
  }

  @override
  Future<void> logout() async {
    _loginResponse = null;
  }

  @override
  Future<void> sendOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    return otp == '123456';
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_management_system_student/data/models/register_response.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../models/login_response.dart';
import '../../network/network_manager.dart';

class RemoteAuthRepository implements AuthRepository {
  LoginResponse? _currentUser;
  static const String _userKey = 'logged_in_user';
  bool _isInitialized = false;

  @override
  Future<LoginResponse?> getCurrentUser() async {
    if (_isInitialized) return _currentUser;

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _currentUser = LoginResponse.fromJson(jsonDecode(userJson));
      } catch (e) {
        await prefs.remove(_userKey);
      }
    }
    _isInitialized = true;
    return _currentUser;
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    LoginResponse loginResponse = await getIt<NetworkManager>().post<LoginResponse>(
      path: '/login',
      body: {'email': email, 'password': password},
      converter: (json) => LoginResponse.fromJson(json),
    );

    if (loginResponse.user != null) {
      _currentUser = loginResponse;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(loginResponse.toJson()));
      _isInitialized = true;
    }
    return loginResponse;
  }

  @override
  Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Capture raw map to check for user data in registration response
    final responseMap = await getIt<NetworkManager>().post<Map<String, dynamic>>(
      path: '/register',
      body: {'name': name, 'email': email, 'password': password},
      converter: (json) => json as Map<String, dynamic>,
    );

    final registrationResponse = RegistrationResponse.fromJson(responseMap);

    if (registrationResponse.isSuccess) {
      // Try to parse user from registration response
      LoginResponse loginData = LoginResponse.fromJson(responseMap);
      
      // If API didn't return user object but registration succeeded, manually create session
      if (loginData.user == null) {
        loginData = LoginResponse(
          message: 'Registration successful',
          user: User(id: 0, name: name, email: email),
        );
      }

      _currentUser = loginData;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(loginData.toJson()));
      _isInitialized = true;
    }

    return registrationResponse;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _isInitialized = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
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

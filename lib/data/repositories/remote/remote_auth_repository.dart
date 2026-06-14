import 'package:learning_management_system_student/data/models/register_response.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../models/login_response.dart';
import '../../network/network_manager.dart';

class RemoteAuthRepository implements AuthRepository {
  LoginResponse? _currentUser;

  @override
  Future<LoginResponse?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    LoginResponse loginResponse = await getIt<NetworkManager>()
        .post<LoginResponse>(
          path: '/login',
          body: {'email': email, 'password': password},
          converter: (json) => LoginResponse.fromJson(json),
        );
    return loginResponse;
  }

  @override
  Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    RegistrationResponse registrationResponse = await getIt<NetworkManager>()
        .post<RegistrationResponse>(
          path: '/register',
          body: {'name': name, 'email': email, 'password': password},
          converter: (json) => RegistrationResponse.fromJson(json),
        );
    return registrationResponse;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
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

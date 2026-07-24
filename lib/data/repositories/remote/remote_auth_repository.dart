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
    required String fullName,
    required String mobileNumber,
    required String gender,
    required String dateOfBirth,
    required String address,
    required String cityStatePin,
    required String emergencyContact,
    required String educationalQualification,
    required String collegeUniversity,
    required String yearOfGraduation,
    required String currentStatus,
    required String currentOrganization,
    required String totalExperience,
    required String businessName,
    required String areasOfInterest,
    required String whyJoinProgram,
    required String businessIdea,
    required String skillsToDevelop,
    required String howHeardAboutProgram,
    required String documentsEnclosed,
    required String declaration,
    required String signature,
    required String declarationDate,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'address': address,
      'city_state_pin': cityStatePin,
      'emergency_contact': emergencyContact,
      'educational_qualification': educationalQualification,
      'college_university': collegeUniversity,
      'year_of_graduation': yearOfGraduation,
      'current_status': currentStatus,
      'current_organization': currentOrganization,
      'total_experience': totalExperience,
      'business_name': businessName,
      'areas_of_interest': areasOfInterest,
      'why_join_program': whyJoinProgram,
      'business_idea': businessIdea,
      'skills_to_develop': skillsToDevelop,
      'how_heard_about_program': howHeardAboutProgram,
      'documents_enclosed': documentsEnclosed,
      'declaration': declaration,
      'signature': signature,
      'declaration_date': declarationDate,
    };

    final responseMap = await getIt<NetworkManager>().post<Map<String, dynamic>>(
      path: '/register',
      body: body,
      converter: (json) => json as Map<String, dynamic>,
    );

    final registrationResponse = RegistrationResponse.fromJson(responseMap);

    if (registrationResponse.isSuccess) {
      LoginResponse loginData = LoginResponse.fromJson(responseMap);
      
      if (loginData.user == null) {
        loginData = LoginResponse(
          message: 'Registration successful',
          user: User(
            id: 0,
            name: name,
            email: email,
            fullName: fullName,
            mobileNumber: mobileNumber,
            gender: gender,
            dateOfBirth: dateOfBirth,
            address: address,
            cityStatePin: cityStatePin,
            emergencyContact: emergencyContact,
            educationalQualification: educationalQualification,
            collegeUniversity: collegeUniversity,
            yearOfGraduation: yearOfGraduation,
            currentStatus: currentStatus,
            currentOrganization: currentOrganization,
            totalExperience: totalExperience,
            businessName: businessName,
            areasOfInterest: areasOfInterest,
            whyJoinProgram: whyJoinProgram,
            businessIdea: businessIdea,
            skillsToDevelop: skillsToDevelop,
            howHeardAboutProgram: howHeardAboutProgram,
            documentsEnclosed: documentsEnclosed,
            declaration: declaration.toLowerCase() == 'true',
            signature: signature,
            declarationDate: declarationDate,
          ),
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

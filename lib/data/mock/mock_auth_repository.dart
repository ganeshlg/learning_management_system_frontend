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
    await Future.delayed(const Duration(seconds: 1));
    _loginResponse = LoginResponse(
      message: 'Login successful',
      user: User(
        id: 1,
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
    return RegistrationResponse(message: RegistrationResponse.successMessage);
  }

  @override
  Future<void> logout() async {
    _loginResponse = null;
  }
}

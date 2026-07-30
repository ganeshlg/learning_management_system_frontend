import 'package:learning_management_system_student/data/models/login_response.dart';
import 'package:learning_management_system_student/data/models/register_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> getCurrentUser();
  Future<LoginResponse> login(String userId, String password);
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
  });
  Future<void> logout();
}

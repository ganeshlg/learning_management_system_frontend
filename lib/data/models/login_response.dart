class LoginResponse {
  static const String successMessage = 'Login successful';

  final String message;
  final User? user;

  LoginResponse({
    required this.message,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user') && json['user'] != null) {
      return LoginResponse(
        message: json['message'] ?? '',
        user: User.fromJson(json['user']),
      );
    }
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
  final String? fullName;
  final String? mobileNumber;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? cityStatePin;
  final String? emergencyContact;
  final String? educationalQualification;
  final String? collegeUniversity;
  final String? yearOfGraduation;
  final String? currentStatus;
  final String? currentOrganization;
  final String? totalExperience;
  final String? businessName;
  final String? areasOfInterest;
  final String? whyJoinProgram;
  final String? businessIdea;
  final String? skillsToDevelop;
  final String? howHeardAboutProgram;
  final String? documentsEnclosed;
  final bool declaration;
  final String? signature;
  final String? declarationDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.fullName,
    this.mobileNumber,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.cityStatePin,
    this.emergencyContact,
    this.educationalQualification,
    this.collegeUniversity,
    this.yearOfGraduation,
    this.currentStatus,
    this.currentOrganization,
    this.totalExperience,
    this.businessName,
    this.areasOfInterest,
    this.whyJoinProgram,
    this.businessIdea,
    this.skillsToDevelop,
    this.howHeardAboutProgram,
    this.documentsEnclosed,
    this.declaration = false,
    this.signature,
    this.declarationDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      fullName: json['full_name'],
      mobileNumber: json['mobile_number'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      cityStatePin: json['city_state_pin'],
      emergencyContact: json['emergency_contact'],
      educationalQualification: json['educational_qualification'],
      collegeUniversity: json['college_university'],
      yearOfGraduation: json['year_of_graduation'],
      currentStatus: json['current_status'],
      currentOrganization: json['current_organization'],
      totalExperience: json['total_experience'],
      businessName: json['business_name'],
      areasOfInterest: json['areas_of_interest'],
      whyJoinProgram: json['why_join_program'],
      businessIdea: json['business_idea'],
      skillsToDevelop: json['skills_to_develop'],
      howHeardAboutProgram: json['how_heard_about_program'],
      documentsEnclosed: json['documents_enclosed'],
      declaration: json['declaration']?.toString().toLowerCase() == 'true',
      signature: json['signature'],
      declarationDate: json['declaration_date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
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
        'declaration': declaration.toString(),
        'signature': signature,
        'declaration_date': declarationDate,
      };
}

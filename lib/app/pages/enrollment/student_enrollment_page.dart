import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:learning_management_system_student/data/models/register_response.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/utils/loading_dialog.dart';

class StudentEnrollmentPage extends StatefulWidget {
  const StudentEnrollmentPage({super.key});

  @override
  State<StudentEnrollmentPage> createState() => _StudentEnrollmentPageState();
}

class _StudentEnrollmentPageState extends State<StudentEnrollmentPage> {
  final _formKey = GlobalKey<FormState>();

  // Basic Info
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Personal Info
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityStatePinController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  // Educational & Professional
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _graduationYearController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();

  // Program Specifics
  final TextEditingController _whyJoinController = TextEditingController();
  final TextEditingController _businessIdeaController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _heardFromController = TextEditingController();

  // Documents & Declaration
  final TextEditingController _signatureController = TextEditingController();

  String _gender = 'Male';
  String _currentStatus = 'Student';
  final List<String> _selectedInterests = [];
  final List<String> _selectedDocuments = [];
  bool _declaration = false;
  final DateTime _declarationDate = DateTime.now();

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _statusOptions = ['Student', 'Employed', 'Business Owner', 'Other'];
  final List<String> _interestOptions = [
    'Contracting', 'Consulting', 'Design', 'PMC', 'Real Estate', 'Materials', 'Other'
  ];
  final List<String> _documentOptions = [
    'Photo', 'ID Proof', 'Resume', 'Degree Certificate', 'Experience Certificate'
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityStatePinController.dispose();
    _emergencyContactController.dispose();
    _educationController.dispose();
    _collegeController.dispose();
    _graduationYearController.dispose();
    _organizationController.dispose();
    _experienceController.dispose();
    _businessNameController.dispose();
    _whyJoinController.dispose();
    _businessIdeaController.dispose();
    _skillsController.dispose();
    _heardFromController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Student Enrollment'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ScreenStabilizer(
          maxWidth: 900,
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Program Application Form',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Become a Civil Entrepreneur. Start your journey today.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('1. Account Setup'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _usernameController,
                            label: 'Username *',
                            icon: Icons.person_outline,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            controller: _emailController,
                            label: 'Email *',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v!.isEmpty) return 'Required';
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _passwordController,
                            label: 'Password *',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password *',
                            icon: Icons.lock_reset,
                            obscureText: true,
                            validator: (v) => v != _passwordController.text ? 'Mismatch' : null,
                          ),
                        ),
                      ],
                    ),

                    _buildSectionTitle('2. Personal Details'),
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name (Official)',
                      icon: Icons.badge_outlined,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _mobileController,
                            label: 'Mobile Number',
                            icon: Icons.phone_android,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: _genderOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (v) => setState(() => _gender = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: IgnorePointer(
                        child: _buildTextField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          icon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Complete Address',
                      icon: Icons.home_outlined,
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _cityStatePinController,
                            label: 'City / State / PIN',
                            icon: Icons.location_city,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            controller: _emergencyContactController,
                            label: 'Emergency Contact',
                            icon: Icons.emergency_outlined,
                          ),
                        ),
                      ],
                    ),

                    _buildSectionTitle('3. Education & Experience'),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _educationController, label: 'Qualification', icon: Icons.school_outlined)),
                        const SizedBox(width: 20),
                        Expanded(child: _buildTextField(controller: _collegeController, label: 'University', icon: Icons.account_balance_outlined)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _graduationYearController, label: 'Year', keyboardType: TextInputType.number)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _currentStatus,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: _statusOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (v) => setState(() => _currentStatus = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(controller: _organizationController, label: 'Current Company', icon: Icons.business_outlined),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _experienceController, label: 'Total Exp (Years)')),
                        const SizedBox(width: 20),
                        Expanded(child: _buildTextField(controller: _businessNameController, label: 'Business Name')),
                      ],
                    ),

                    _buildSectionTitle('4. Program Specifics'),
                    const Text('Primary Areas of Interest:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _interestOptions.map((interest) {
                        final isSelected = _selectedInterests.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: isSelected,
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _whyJoinController,
                      label: 'Statement of Purpose (Why join?)',
                      maxLines: 3,
                    ),
                    _buildTextField(
                      controller: _businessIdeaController,
                      label: 'Brief Business Idea (if any)',
                      maxLines: 3,
                    ),
                    _buildTextField(
                      controller: _skillsController,
                      label: 'Skills you want to acquire',
                      maxLines: 2,
                    ),
                    _buildTextField(controller: _heardFromController, label: 'How did you hear about us?', icon: Icons.campaign_outlined),

                    _buildSectionTitle('5. Documents & Consent'),
                    const Text('Check the documents you can provide:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 4,
                      children: _documentOptions.map((doc) {
                        return CheckboxListTile(
                          title: Text(doc, style: const TextStyle(fontSize: 14)),
                          value: _selectedDocuments.contains(doc),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            setState(() {
                              if (val!) _selectedDocuments.add(doc);
                              else _selectedDocuments.remove(doc);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _signatureController,
                      label: 'Digital Signature (Type Full Name)',
                      icon: Icons.edit_note,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: const Text(
                              'I certify that all information provided is true and correct to the best of my knowledge.',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            value: _declaration,
                            onChanged: (v) => setState(() => _declaration = v!),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Divider(),
                          Text('Submitted on: ${DateFormat('MMMM dd, yyyy').format(_declarationDate)}'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (!_declaration) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please accept the declaration')),
                          );
                          return;
                        }

                        showLoadingDialog(context, message: "Submitting your application... This will take about 10 seconds.");
                        try {
                          final response = await getIt<AuthRepository>().register(
                            name: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            fullName: _fullNameController.text,
                            mobileNumber: _mobileController.text,
                            gender: _gender,
                            dateOfBirth: _dobController.text,
                            address: _addressController.text,
                            cityStatePin: _cityStatePinController.text,
                            emergencyContact: _emergencyContactController.text,
                            educationalQualification: _educationController.text,
                            collegeUniversity: _collegeController.text,
                            yearOfGraduation: _graduationYearController.text,
                            currentStatus: _currentStatus,
                            currentOrganization: _organizationController.text,
                            totalExperience: _experienceController.text,
                            businessName: _businessNameController.text,
                            areasOfInterest: _selectedInterests.join(', '),
                            whyJoinProgram: _whyJoinController.text,
                            businessIdea: _businessIdeaController.text,
                            skillsToDevelop: _skillsController.text,
                            howHeardAboutProgram: _heardFromController.text,
                            documentsEnclosed: _selectedDocuments.join(', '),
                            declaration: _declaration.toString(),
                            signature: _signatureController.text,
                            declarationDate: DateFormat('yyyy-MM-dd').format(_declarationDate),
                          );

                          if (response.isSuccess) {
                            // Wait 10 seconds before redirecting
                            await Future.delayed(const Duration(seconds: 10));
                            if (mounted) {
                              Navigator.pop(context); // Dismiss loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Application Submitted Successfully!"),
                                ),
                              );
                              context.go('/enrollment-success');
                            }
                          } else {
                            if (mounted) {
                              Navigator.pop(context); // Dismiss loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(backgroundColor: Colors.red, content: Text(response.message)),
                              );
                            }
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.red, content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Text('SUBMIT APPLICATION', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => context.go('/auth'),
                      child: const Text('Already registered? Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

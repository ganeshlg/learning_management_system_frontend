import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:learning_management_system_student/data/models/register_response.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/utils/loading_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const Divider(),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenStabilizer(
        maxWidth: 800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Application Form',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please fill in all details accurately to enroll in the program.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                _buildSectionTitle('Account Credentials'),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                ),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                  validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                ),

                _buildSectionTitle('Personal Information'),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name (As per Documents)',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: _mobileController,
                  label: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                        items: _genderOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => _gender = v!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: IgnorePointer(
                          child: _buildTextField(
                            controller: _dobController,
                            label: 'Date of Birth',
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Permanent Address',
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: _cityStatePinController,
                  label: 'City / State / PIN',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: _emergencyContactController,
                  label: 'Emergency Contact (Name & Phone)',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                _buildSectionTitle('Educational & Professional Details'),
                _buildTextField(controller: _educationController, label: 'Highest Qualification'),
                _buildTextField(controller: _collegeController, label: 'College / University'),
                _buildTextField(controller: _graduationYearController, label: 'Year of Graduation', keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: _currentStatus,
                  decoration: const InputDecoration(labelText: 'Current Status', border: OutlineInputBorder()),
                  items: _statusOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _currentStatus = v!),
                ),
                const SizedBox(height: 16),
                _buildTextField(controller: _organizationController, label: 'Current Organization (If any)'),
                _buildTextField(controller: _experienceController, label: 'Total Experience (Years)'),
                _buildTextField(controller: _businessNameController, label: 'Business Name (If any)'),

                _buildSectionTitle('Program Interest'),
                const Text('Areas of Interest:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _interestOptions.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: isSelected,
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
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _whyJoinController,
                  label: 'Why do you want to join this program?',
                  maxLines: 3,
                ),
                _buildTextField(
                  controller: _businessIdeaController,
                  label: 'Any specific business idea you have?',
                  maxLines: 3,
                ),
                _buildTextField(
                  controller: _skillsController,
                  label: 'What skills do you wish to develop?',
                  maxLines: 2,
                ),
                _buildTextField(controller: _heardFromController, label: 'How did you hear about us?'),

                _buildSectionTitle('Documents & Declaration'),
                const Text('Documents you will submit:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ..._documentOptions.map((doc) {
                  return CheckboxListTile(
                    title: Text(doc),
                    value: _selectedDocuments.contains(doc),
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() {
                        if (val!) {
                          _selectedDocuments.add(doc);
                        } else {
                          _selectedDocuments.remove(doc);
                        }
                      });
                    },
                  );
                }),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _signatureController,
                  label: 'Digital Signature (Type your Full Name)',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                Text('Date: ${DateFormat('yyyy-MM-dd').format(_declarationDate)}'),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('I certify that the information provided is true to the best of my knowledge.'),
                  value: _declaration,
                  onChanged: (v) => setState(() => _declaration = v!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    if (!_declaration) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please accept the declaration')),
                      );
                      return;
                    }

                    showLoadingDialog(context);
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

                      if (mounted) Navigator.pop(context); // Close loading dialog

                      if (response.isSuccess) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Enrollment Successful! Welcome to the program."),
                            ),
                          );
                          context.go('/dashboard/${_fullNameController.text}');
                        }
                      } else {
                        if (mounted) {
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('SUBMIT ENROLLMENT'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already enrolled?"),
                    TextButton(
                      onPressed: () => context.go('/auth'),
                      child: const Text('Login here'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

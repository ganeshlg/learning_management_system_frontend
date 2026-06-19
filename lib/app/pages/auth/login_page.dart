import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_management_system_student/data/network/network_manager.dart';
import 'package:learning_management_system_student/domain/repositories/auth_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/models/login_response.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/utils/loading_dialog.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenStabilizer(
        maxWidth: 500,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Login',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'User ID / Email',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                // onPressed: () => context.go('/dashboard'),
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          "Please fill all the fields",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    showLoadingDialog(context);
                    LoginResponse loginResponse = await getIt<AuthRepository>()
                        .login(emailController.text, passwordController.text);
                    Navigator.pop(context);
                    if (loginResponse.isSuccess) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     backgroundColor: Colors.green,
                      //     content: Text(
                      //       "Login Successful!\n\nYour journey from engineer to entrepreneur continues here. Learn, innovate, and create infrastructure that makes a lasting impact.",
                      //       style: const TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // );

                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //       title: const Text(
                      //         'Login Successful!',
                      //         style: TextStyle(color: Colors.green),
                      //       ),
                      //       content: const Text(
                      //         'Your journey from engineer to entrepreneur continues here. '
                      //             'Learn, innovate, and create infrastructure that makes a lasting impact.',
                      //       ),
                      //       actions: [
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop(); // Close dialog
                      //             context.go('/dashboard/${loginResponse.user?.name}');
                      //           },
                      //           child: const Text('Continue'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );

                      context.go('/dashboard/${loginResponse.user?.name}');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            loginResponse.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
              // const SizedBox(height: 16),
              // OutlinedButton.icon(
              //   onPressed: () {},
              //   icon: const Icon(Icons.login),
              //   label: const Text('Continue with Google'),
              // ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => context.go('/auth/register'),
                    child: const Text('Register'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

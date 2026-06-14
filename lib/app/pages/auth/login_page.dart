import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_management_system_student/data/network/network_manager.dart';
import 'package:learning_management_system_student/domain/repositories/auth_repository.dart';
import '../../../data/models/login_response.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';
import '../../../domain/services/service_locator.dart';

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
                    LoginResponse loginResponse = await getIt<AuthRepository>().login(
                      emailController.text,
                      passwordController.text,
                    );
                    if(loginResponse.isSuccess){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Login Successful!\n\nYour journey from engineer to entrepreneur continues here. Learn, innovate, and create infrastructure that makes a lasting impact.",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                      context.go('/dashboard/${loginResponse.user?.name}');
                    }else{
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
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
              ),
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

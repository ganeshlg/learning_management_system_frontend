import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ScreenStabilizer(
        maxWidth: 500,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (_step == 1) _buildStep1(),
              if (_step == 2) _buildStep2(),
              if (_step == 3) _buildStep3(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        const Text('Enter your email to receive an OTP', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        const TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => setState(() => _step = 2), child: const Text('Send OTP')),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const Text('Enter the 6-digit OTP sent to your email', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        const TextField(decoration: InputDecoration(labelText: 'OTP', border: OutlineInputBorder())),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => setState(() => _step = 3), child: const Text('Verify OTP')),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        const Text('Create a new password', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        const TextField(obscureText: true, decoration: InputDecoration(labelText: 'New Password', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder())),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => context.go('/auth'), child: const Text('Reset Password')),
      ],
    );
  }
}

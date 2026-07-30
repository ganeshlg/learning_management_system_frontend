import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/utils/encryption_util.dart';
import '../../../domain/entities/purchase.dart';

class PaymentVerificationPage extends StatefulWidget {
  final String email;
  final String courseId;

  const PaymentVerificationPage({
    super.key,
    required this.email,
    required this.courseId,
  });

  @override
  State<PaymentVerificationPage> createState() => _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  int _attempts = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    _verifyPayment();
  }

  Future<void> _verifyPayment() async {
    setState(() => _attempts++);
    
    try {
      // Small delay to allow backend sync
      await Future.delayed(const Duration(seconds: 3));
      
      final details = await getIt<PaymentRepository>().getPurchaseDetails(
        email: widget.email,
        courseId: widget.courseId,
      );

      if (details != null && mounted) {
        // Success! Go to the success page with the fresh data
        final eid = EncryptionUtil.encrypt("${widget.email}|${widget.courseId}");
        context.go('/payment-success/$eid', extra: details);
      } else if (_attempts < _maxAttempts) {
        // Retry
        _verifyPayment();
      } else {
        // Failed to verify after retries
        if (mounted) {
          setState(() {}); // Trigger build to show error
        }
      }
    } catch (e) {
      if (_attempts < _maxAttempts) {
        _verifyPayment();
      } else if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(strokeWidth: 6),
              ),
              const SizedBox(height: 32),
              Text(
                "Verifying Payment...",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "We are syncing your payment details with our secure servers. This usually takes a few seconds.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              if (_attempts >= _maxAttempts) ...[
                const SizedBox(height: 32),
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "It's taking longer than expected. Please don't worry, your payment is safe.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _verifyPayment(),
                  child: const Text("RETRY VERIFICATION"),
                ),
                TextButton(
                  onPressed: () => context.go('/dashboard/Student'),
                  child: const Text("GO TO DASHBOARD"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

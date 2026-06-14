import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_gateway.dart';

class MockRazorpayGateway implements PaymentGateway {
  @override
  Future<Payment> processPayment(String courseId, double amount) async {
    // Simulating Razorpay popup delay
    await Future.delayed(const Duration(seconds: 2));
    return Payment(
      id: 'rzp_${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      amount: amount,
      status: PaymentStatus.success,
      createdAt: DateTime.now(),
    );
  }
}

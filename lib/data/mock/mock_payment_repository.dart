import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

class MockPaymentRepository implements PaymentRepository {
  @override
  Future<Payment> processPayment(String courseId, double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    return Payment(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      amount: amount,
      status: PaymentStatus.success,
      createdAt: DateTime.now(),
    );
  }
}

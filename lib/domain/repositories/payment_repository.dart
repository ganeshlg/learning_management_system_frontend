import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Payment> processPayment(String courseId, double amount);
}

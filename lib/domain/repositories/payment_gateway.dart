import '../entities/payment.dart';

abstract class PaymentGateway {
  Future<Payment> processPayment(String courseId, double amount);
}

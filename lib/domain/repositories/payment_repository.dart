import '../entities/payment.dart';
import '../entities/purchase.dart';

abstract class PaymentRepository {
  Future<Payment> processPayment(String courseId, double amount);
  Future<bool> recordPayment({
    required String courseId,
    required double amount,
    required String paymentId,
    required String status,
    required String plan,
  });

  Future<Purchase?> purchaseCourse({
    required String email,
    required String courseId,
    required String paymentPlan,
    required int paidInstallments,
    required String password,
    required String name,
  });

  Future<Purchase?> getPurchaseDetails({
    required String email,
    required String courseId,
  });

  Future<Purchase?> updatePurchase({
    required String email,
    required String courseId,
    required String paymentPlan,
    required int paidInstallments,
    required String name,
  });
}

import '../../../domain/entities/payment.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../network/network_manager.dart';
import '../../../domain/services/service_locator.dart';

class RemotePaymentRepository implements PaymentRepository {
  @override
  Future<Payment> processPayment(String courseId, double amount) async {
    // This usually involves calling the payment gateway directly (like Razorpay)
    // For the context of this project, we handle it in the UI and then call recordPayment/purchaseCourse
    return Payment(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      amount: amount,
      status: PaymentStatus.success,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<bool> recordPayment({
    required String courseId,
    required double amount,
    required String paymentId,
    required String status,
    required String plan,
  }) async {
    // Similar to purchaseCourse but specifically for recording the transaction
    return true;
  }

  @override
  Future<Purchase?> purchaseCourse({
    required String email,
    required String courseId,
    required String paymentPlan,
    required int paidInstallments,
    required String password,
    required String name,
  }) async {
    return await getIt<NetworkManager>().post<Purchase?>(
      path: '/purchase',
      body: {
        'email': email,
        'course_id': courseId,
        'payment_plan': paymentPlan,
        'paid_installments': paidInstallments,
        'password': password,
        'name': name,
      },
      converter: (json) {
        if (json == null) return null;
        // The API returns {"message": "Purchase recorded"} on success.
        // We might need to map it back to a Purchase entity if needed by the UI.
        // Since we are mocking the entity from the response:
        return Purchase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'remote_user',
          courseId: courseId,
          paymentPlan: paymentPlan,
          paidInstallments: paidInstallments,
          status: 'active',
          purchasedAt: DateTime.now(),
          userEmail: email,
          courseTitle: 'Course Title', // Ideally returned by the API or fetched separately
        );
      },
    );
  }

  @override
  Future<Purchase?> getPurchaseDetails({
    required String email,
    required String courseId,
  }) async {
    return await getIt<NetworkManager>().get<Purchase?>(
      path: '/purchases/details',
      queryParameters: {
        'email': email,
        'course_id': courseId,
      },
      converter: (json) {
        if (json == null || json['purchase'] == null) return null;
        final p = json['purchase'];
        return Purchase(
          id: p['id']?.toString() ?? '',
          userId: p['user_id']?.toString() ?? '',
          courseId: p['course_id']?.toString() ?? '',
          paymentPlan: p['payment_plan'] ?? '',
          paidInstallments: int.tryParse(p['paid_installments']?.toString() ?? '0') ?? 0,
          status: p['status'] ?? 'active',
          purchasedAt: DateTime.tryParse(p['purchased_at'] ?? '') ?? DateTime.now(),
          userEmail: p['user_email'] ?? email,
          courseTitle: p['course_title'] ?? '',
        );
      },
    );
  }

  @override
  Future<Purchase?> updatePurchase({
    required String email,
    required String courseId,
    required String paymentPlan,
    required int paidInstallments,
    required String name,
  }) async {
    return await getIt<NetworkManager>().put<Purchase?>(
      path: '/purchase',
      body: {
        'email': email,
        'course_id': courseId,
        'payment_plan': paymentPlan,
        'paid_installments': paidInstallments,
        'name': name,
      },
      converter: (json) {
        if (json == null) return null;
        return Purchase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'remote_user',
          courseId: courseId,
          paymentPlan: paymentPlan,
          paidInstallments: paidInstallments,
          status: 'active',
          purchasedAt: DateTime.now(),
          userEmail: email,
          courseTitle: 'Course Title',
        );
      },
    );
  }
}

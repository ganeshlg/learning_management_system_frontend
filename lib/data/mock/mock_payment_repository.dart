import '../../domain/entities/payment.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/services/service_locator.dart';

class MockPaymentRepository implements PaymentRepository {
  final List<Purchase> _mockPurchases = [];

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

  @override
  Future<bool> recordPayment({
    required String courseId,
    required double amount,
    required String paymentId,
    required String status,
    required String plan,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    print('Payment Recorded: Course: $courseId, Amount: $amount, ID: $paymentId, Plan: $plan');
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
    await Future.delayed(const Duration(seconds: 1));

    final existingIndex = _mockPurchases.indexWhere(
      (p) => p.userEmail == email && p.courseId == courseId,
    );

    if (existingIndex != -1) {
      final existing = _mockPurchases[existingIndex];
      final updated = Purchase(
        id: existing.id,
        userId: existing.userId,
        courseId: existing.courseId,
        paymentPlan: paymentPlan,
        paidInstallments: paidInstallments,
        status: 'active',
        purchasedAt: DateTime.now(),
        userEmail: email,
        courseTitle: existing.courseTitle,
      );
      _mockPurchases[existingIndex] = updated;
      return updated;
    }

    final courseRepo = getIt<CourseRepository>();
    final course = await courseRepo.getCourseById(courseId);

    final newPurchase = Purchase(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_10',
      courseId: courseId,
      paymentPlan: paymentPlan,
      paidInstallments: paidInstallments,
      status: 'active',
      purchasedAt: DateTime.now(),
      userEmail: email,
      courseTitle: course?.title ?? 'Sample Course',
    );

    _mockPurchases.add(newPurchase);
    return newPurchase;
  }

  @override
  Future<Purchase?> getPurchaseDetails({
    required String email,
    required String courseId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockPurchases.firstWhere(
        (p) => p.userEmail == email && p.courseId == courseId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Purchase?> updatePurchase({
    required String email,
    required String courseId,
    required String paymentPlan,
    required int paidInstallments,
    required String name,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final index = _mockPurchases.indexWhere(
      (p) => p.userEmail == email && p.courseId == courseId,
    );

    if (index != -1) {
      final existing = _mockPurchases[index];
      final updated = Purchase(
        id: existing.id,
        userId: existing.userId,
        courseId: existing.courseId,
        paymentPlan: paymentPlan,
        paidInstallments: paidInstallments,
        status: 'active',
        purchasedAt: DateTime.now(),
        userEmail: email,
        courseTitle: existing.courseTitle,
      );
      _mockPurchases[index] = updated;
      return updated;
    }
    return null;
  }
}

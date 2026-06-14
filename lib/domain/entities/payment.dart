enum PaymentStatus { pending, success, failed }

class Payment {
  final String id;
  final String courseId;
  final double amount;
  final PaymentStatus status;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.courseId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });
}

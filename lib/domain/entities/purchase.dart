class Purchase {
  final String id;
  final String userId;
  final String courseId;
  final String paymentPlan; // 'one_time', '2_installments', '3_installments'
  final int paidInstallments;
  final String status; // 'active', 'pending', 'completed'
  final DateTime purchasedAt;
  final String userEmail;
  final String courseTitle;

  Purchase({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.paymentPlan,
    required this.paidInstallments,
    required this.status,
    required this.purchasedAt,
    required this.userEmail,
    required this.courseTitle,
  });

  bool get isFullyPaid {
    if (paymentPlan == 'one_time') return true;
    if (paymentPlan == '2_installments' && paidInstallments >= 2) return true;
    if (paymentPlan == '3_installments' && paidInstallments >= 3) return true;
    return false;
  }
}

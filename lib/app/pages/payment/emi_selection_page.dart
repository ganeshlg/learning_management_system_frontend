import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_web/razorpay_web.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';
import '../../../domain/utils/encryption_util.dart';
import '../../../domain/utils/loading_dialog.dart';

class EMISelectionPage extends StatefulWidget {
  final Course? course;
  final String? encryptedCourseId;

  const EMISelectionPage({super.key, this.course, this.encryptedCourseId});

  @override
  State<EMISelectionPage> createState() => _EMISelectionPageState();
}

class _EMISelectionPageState extends State<EMISelectionPage> {
  late Razorpay _razorpay;
  int _selectedOption = 0;
  Course? _course;
  Purchase? _existingPurchase;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _loadData();
  }

  String? _userEmail;
  String? _userName;

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      String? courseId;
      if (widget.encryptedCourseId != null) {
        final decrypted = EncryptionUtil.decrypt(widget.encryptedCourseId!);
        // Support "email|id" or "email|id|name" or just "id"
        if (decrypted.contains('|')) {
          final parts = decrypted.split('|');
          _userEmail = parts[0];
          courseId = parts[1];
          if (parts.length > 2) _userName = parts[2];
        } else {
          courseId = decrypted;
        }
      } else if (widget.course != null) {
        courseId = widget.course!.id;
      }

      if (courseId == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Load course if not provided
      if (_course == null) {
        _course = await getIt<CourseRepository>().getCourseById(courseId);
      }

      // Fetch user email if not provided from link
      if (_userEmail == null) {
        final currentUser = await getIt<AuthRepository>().getCurrentUser();
        if (currentUser?.user != null) {
          _userEmail = currentUser!.user!.email;
          _userName = currentUser.user!.name;
        }
      }

      // Check for existing purchase
      if (_userEmail != null && _course != null) {
        _existingPurchase = await getIt<PaymentRepository>().getPurchaseDetails(
          email: _userEmail!,
          courseId: _course!.id,
        );
        if (_existingPurchase != null && !_existingPurchase!.isFullyPaid) {
          _selectedOption = 0;
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading data: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_course == null) return;

    // Use existing purchase details if available to maintain plan consistency
    final planKey = _existingPurchase != null && !_existingPurchase!.isFullyPaid
        ? _existingPurchase!.paymentPlan
        : _getPlans(_course!.price)[_selectedOption].key;

    // Priority: 1. Link Data, 2. Auth Session, 3. Default
    String email = _userEmail ?? 'student@example.com';
    String name = _userName ?? 'User Name';

    if (_userEmail == null) {
      final currentUser = await getIt<AuthRepository>().getCurrentUser();
      if (currentUser?.user != null) {
        email = currentUser!.user!.email;
        name = currentUser.user!.name;
      }
    }

    final installmentsToPay = (_existingPurchase?.paidInstallments ?? 0) + 1;
    Purchase? purchase;

    if (mounted) {
      showLoadingDialog(context, message: "Verifying your payment... This will take about 10 seconds.");
    }

    try {
      if (_existingPurchase != null) {
        // Use PUT for updating existing EMI
        purchase = await getIt<PaymentRepository>().updatePurchase(
          email: email,
          courseId: _course!.id,
          paymentPlan: planKey,
          paidInstallments: installmentsToPay,
          name: name,
        );
      } else {
        // Use POST for new purchase
        purchase = await getIt<PaymentRepository>().purchaseCourse(
          email: email,
          courseId: _course!.id,
          paymentPlan: planKey,
          paidInstallments: installmentsToPay,
          password: '123456',
          name: name,
        );
      }

      // Mandatory 10-second wait after successful API call or attempt
      await Future.delayed(const Duration(seconds: 10));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing enrollment: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog
      }
    }

    if (purchase != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful!"), backgroundColor: Colors.green),
      );
      final eid = EncryptionUtil.encrypt("${purchase.userEmail}|${purchase.courseId}");
      // Add a timestamp to force GoRouter to treat this as a unique navigation event
      final ts = DateTime.now().millisecondsSinceEpoch;
      context.go('/payment-verify/$eid?t=$ts', extra: purchase);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}"), backgroundColor: Colors.red),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void _startPayment(double amount) async {
    if (_course == null) return;

    final plans = _getPlans(_course!.price);
    final selectedPlan = plans[_selectedOption];

    String email = _userEmail ?? 'student@example.com';
    String contact = '9876543210';

    if (_userEmail == null) {
      final currentUser = await getIt<AuthRepository>().getCurrentUser();
      if (currentUser?.user != null) {
        email = currentUser!.user!.email;
        contact = currentUser.user!.mobileNumber ?? contact;
      }
    }

    var options = {
      'key': 'rzp_test_T8vzORpiM50W5O',
      'amount': (amount * 100).toInt(),
      'name': 'Civil Entrepreneurship',
      'description': 'Course Enrollment: ${_course!.title}',
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'notes': {
        'course_id': _course!.id,
        'payment_plan': selectedPlan.key,
        'installments_paid': '1',
      }
    };

    try {
      _razorpay.open(options, context: context);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  List<_PaymentPlan> _getPlans(double basePrice) {
    return [
      _PaymentPlan(
        key: 'one_time',
        title: "Full Payment",
        description: "Pay the full amount now and get immediate access.",
        totalAmount: basePrice,
        installments: 1,
        amountPerInstallment: basePrice,
      ),
      _PaymentPlan(
        key: '2_installments',
        title: "2 Months EMI",
        description: "Pay in 2 installments. (10% program fee increase)",
        totalAmount: basePrice * 1.1,
        installments: 2,
        amountPerInstallment: (basePrice * 1.1) / 2,
      ),
      _PaymentPlan(
        key: '3_installments',
        title: "3 Months EMI",
        description: "Pay in 3 installments. (20% program fee increase)",
        totalAmount: basePrice * 1.2,
        installments: 3,
        amountPerInstallment: (basePrice * 1.2) / 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Payment")),
        body: const Center(child: Text("Course not found or invalid link.")),
      );
    }

    if (_existingPurchase != null && _existingPurchase!.isFullyPaid) {
      return Scaffold(
        appBar: AppBar(title: const Text("Enrollment Status")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              Text(
                "Already Enrolled!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("You have already completed the payment for this course."),
            ],
          ),
        ),
      );
    }

    List<_PaymentPlan> plans;
    if (_existingPurchase != null && !_existingPurchase!.isFullyPaid) {
      // If there's an ongoing EMI, only show that specific plan
      final allPlans = _getPlans(_course!.price);
      plans = allPlans.where((p) => p.key == _existingPurchase!.paymentPlan).toList();
    } else {
      plans = _getPlans(_course!.price);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Select Payment Plan")),
      body: ScreenStabilizer(
        maxWidth: 800,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _existingPurchase != null && !_existingPurchase!.isFullyPaid
                    ? "Pay Next Installment for ${_course!.title}"
                    : "Enroll in ${_course!.title}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _existingPurchase != null && !_existingPurchase!.isFullyPaid
                    ? "Installment ${_existingPurchase!.paidInstallments + 1} of ${_existingPurchase!.paymentPlan.split('_')[0]}"
                    : "Select a payment option that suits you best.",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: plans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final isSelected = _selectedOption == index;
                    return InkWell(
                      onTap: _existingPurchase != null && !_existingPurchase!.isFullyPaid
                          ? null // Disable switching if paying EMI
                          : () => setState(() => _selectedOption = index),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                            width: 2,
                          ),
                          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.white,
                        ),
                        child: Row(
                          children: [
                            if (_existingPurchase == null || _existingPurchase!.isFullyPaid)
                              Radio<int>(
                                value: index,
                                groupValue: _selectedOption,
                                onChanged: (v) => setState(() => _selectedOption = v!),
                              )
                            else
                              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(plan.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(plan.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${plan.amountPerInstallment.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  plan.installments == 1 ? "one-time" : "x ${plan.installments} months",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _existingPurchase != null && !_existingPurchase!.isFullyPaid
                              ? "Installment Amount:"
                              : "Total Payable Amount:",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "₹${plans[_selectedOption].amountPerInstallment.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _startPayment(plans[_selectedOption].amountPerInstallment),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _existingPurchase != null && !_existingPurchase!.isFullyPaid
                              ? "PAY INSTALLMENT"
                              : "PROCEED TO PAY",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentPlan {
  final String key;
  final String title;
  final String description;
  final double totalAmount;
  final int installments;
  final double amountPerInstallment;

  _PaymentPlan({
    required this.key,
    required this.title,
    required this.description,
    required this.totalAmount,
    required this.installments,
    required this.amountPerInstallment,
  });
}

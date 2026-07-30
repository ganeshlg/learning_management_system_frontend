import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/utils/encryption_util.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String email;
  final String courseId;
  final Purchase? initialPurchase;

  const PaymentSuccessPage({
    super.key,
    required this.email,
    required this.courseId,
    this.initialPurchase,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  Purchase? _purchase;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPurchaseDetails();
  }

  @override
  void didUpdateWidget(covariant PaymentSuccessPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchPurchaseDetails();
  }

  Future<void> _fetchPurchaseDetails() async {
    if (widget.email.isEmpty || widget.courseId.isEmpty) {
      setState(() {
        _errorMessage = "email and course_id query parameters are required";
        _isLoading = false;
      });
      return;
    }

    try {
      final details = await getIt<PaymentRepository>().getPurchaseDetails(
        email: widget.email,
        courseId: widget.courseId,
      );

      if (details == null) {
        setState(() {
          _errorMessage = "Purchase not found for this user and course";
          _isLoading = false;
        });
      } else {
        setState(() {
          _purchase = details;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      // Handle "User not found" or other errors from the repository
      setState(() {
        _errorMessage = "User not found";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Payment Status")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 80),
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (_errorMessage == "Purchase not found for this user and course")
                  ElevatedButton(
                    onPressed: () {
                      final eid = EncryptionUtil.encrypt("${widget.email}|${widget.courseId}");
                      context.go('/payment/$eid');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("PROCEED TO EMI SELECTION"),
                  )
                else
                  ElevatedButton(
                    onPressed: () => context.go('/auth'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text("BACK TO LOGIN"),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Successful")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 24),
                Text(
                  "Thank you for your purchase!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  _purchase!.courseTitle,
                  style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
                const SizedBox(height: 32),
                _buildInfoCard(),
                const SizedBox(height: 32),
                if (!_purchase!.isFullyPaid)
                  _buildNextInstallmentAction()
                else
                  const Text("Course Access: FULLY PAID",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _infoRow("Email", _purchase!.userEmail),
            const Divider(),
            _infoRow("Plan", _purchase!.paymentPlan.replaceAll('_', ' ').toUpperCase()),
            const Divider(),
            _infoRow("Installments Paid", "${_purchase!.paidInstallments}"),
            const Divider(),
            _infoRow("Status", _purchase!.status.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNextInstallmentAction() {
    return Column(
      children: [
        const Text(
          "You have remaining installments.",
          style: TextStyle(color: Colors.orange),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            final eid = EncryptionUtil.encrypt("${widget.email}|${widget.courseId}");
            context.push('/payment/$eid');
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("PAY NEXT INSTALLMENT"),
        ),
      ],
    );
  }
}

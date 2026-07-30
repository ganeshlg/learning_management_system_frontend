import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/utils/encryption_util.dart';
import '../pages/enrollment/enrollment_page.dart';
import '../pages/enrollment/student_enrollment_page.dart';
import '../pages/enrollment/enrollment_success_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/course/course_details_page.dart';
import '../pages/summary/course_summary_page.dart';
import '../pages/payment/emi_selection_page.dart';
import '../pages/payment/payment_success_page.dart';
import '../pages/payment/payment_verification_page.dart';
import '../../domain/entities/course.dart';

class AppRouter {
  static final router = GoRouter(
    // initialLocation: '/',
    // initialLocation: '/payment-success/Z2FuZXNobGcyMTA4QGdtYWlsLmNvbXwyNzQ4Njc4Mjk1',
    initialLocation: '/auth',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const EnrollmentPage()),
      GoRoute(path: '/enroll', builder: (context, state) => const StudentEnrollmentPage()),
      GoRoute(path: '/enrollment-success', builder: (context, state) => const EnrollmentSuccessPage()),
      GoRoute(
        path: '/auth',
        builder: (context, state) => LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => RegisterPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard/:name',
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          return DashboardPage(name: name);
        },
      ),
      GoRoute(
        path: '/course/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CourseDetailsPage(courseId: id);
        },
      ),
      GoRoute(
        path: '/course-summary/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CourseSummaryPage(courseId: id);
        },
      ),
      GoRoute(
        path: '/pay',
        builder: (context, state) {
          final course = state.extra as Course?;
          return EMISelectionPage(course: course);
        },
      ),
      GoRoute(
        path: '/payment/:eid',
        builder: (context, state) {
          final eid = state.pathParameters['eid']!;
          return EMISelectionPage(encryptedCourseId: eid);
        },
      ),
      GoRoute(
        path: '/payment-verify/:eid',
        builder: (context, state) {
          final eid = state.pathParameters['eid']!;
          final decrypted = EncryptionUtil.decrypt(eid);
          String email = '';
          String courseId = '';
          if (decrypted.contains('|')) {
            final parts = decrypted.split('|');
            email = parts[0];
            courseId = parts[1];
          }
          return PaymentVerificationPage(email: email, courseId: courseId);
        },
      ),
      GoRoute(
        path: '/payment-success/:eid',
        builder: (context, state) {
          final eid = state.pathParameters['eid']!;
          final purchase = state.extra as Purchase?;
          final decrypted = EncryptionUtil.decrypt(eid);
          String email = '';
          String courseId = '';
          if (decrypted.contains('|')) {
            final parts = decrypted.split('|');
            email = parts[0];
            courseId = parts[1];
          }
          return PaymentSuccessPage(
            key: ValueKey(DateTime.now().toString()),
            email: email,
            courseId: courseId,
            initialPurchase: purchase
          );
        },
      ),
    ],
  );
}

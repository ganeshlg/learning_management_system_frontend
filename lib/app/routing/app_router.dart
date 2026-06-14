import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/enrollment/enrollment_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/course/course_details_page.dart';
import '../pages/summary/course_summary_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const EnrollmentPage()),
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
    ],
  );
}

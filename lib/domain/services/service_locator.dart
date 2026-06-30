import 'package:get_it/get_it.dart';
import 'package:learning_management_system_student/data/repositories/remote/remote_auth_repository.dart';
import 'package:learning_management_system_student/data/repositories/remote/remote_course_repository.dart';
import '../../data/mock/mock_auth_repository.dart';
import '../../data/mock/mock_course_repository.dart';
import '../../data/mock/mock_payment_repository.dart';
import '../../data/mock/mock_progress_repository.dart';
import '../../data/network/network_manager.dart';
import '../repositories/auth_repository.dart';
import '../repositories/course_repository.dart';
import '../repositories/payment_repository.dart';
import '../repositories/progress_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // getIt.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  // getIt.registerLazySingleton<CourseRepository>(() => MockCourseRepository());
  getIt.registerLazySingleton<PaymentRepository>(() => MockPaymentRepository());
  getIt.registerLazySingleton<ProgressRepository>(() => MockProgressRepository());

  //Remote Repositories
  getIt.registerLazySingleton<AuthRepository>(() => RemoteAuthRepository());
  getIt.registerLazySingleton<CourseRepository>(() => RemoteCourseRepository());

  //Network Manager
  getIt.registerLazySingleton<NetworkManager>(
    () => NetworkManager(
      // baseUrl: 'http://localhost:8000/api',
      baseUrl: 'https://learning-management-system-api-gateway-v1.onrender.com/api',
      allowBadCertificates: false,
    ),
  );
}

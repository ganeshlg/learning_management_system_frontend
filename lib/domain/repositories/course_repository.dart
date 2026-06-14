import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getAvailableCourses();
  Future<List<Course>> getPurchasedCourses();
  Future<Course?> getCourseById(String id);
  Future<void> purchaseCourse(String id);
}

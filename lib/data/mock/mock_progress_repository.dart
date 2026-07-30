import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/services/service_locator.dart';

class MockProgressRepository implements ProgressRepository {
  final Map<String, Set<String>> _completedLessons = {};

  @override
  Future<double> getCourseProgress(String courseId) async {
    final course = await getIt<CourseRepository>().getCourseById(courseId);
    if (course == null) return 0.0;

    int totalLessons = 0;
    for (var module in course.modules) {
      totalLessons += module.lessons.length;
    }

    if (totalLessons == 0) return 0.0;

    final completedCount = _completedLessons[courseId]?.length ?? 0;
    return completedCount / totalLessons;
  }

  @override
  Future<void> markLessonAsComplete(String courseId, String lessonId) async {
    _completedLessons.putIfAbsent(courseId, () => {}).add(lessonId);
  }

  @override
  Future<bool> isLessonCompleted(String courseId, String lessonId) async {
    return _completedLessons[courseId]?.contains(lessonId) ?? false;
  }
}

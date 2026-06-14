import '../../domain/repositories/progress_repository.dart';

class MockProgressRepository implements ProgressRepository {
  final Map<String, Set<String>> _completedLessons = {};

  @override
  Future<double> getCourseProgress(String courseId) async {
    if (courseId == '1') return 0;
    return 0.0;
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

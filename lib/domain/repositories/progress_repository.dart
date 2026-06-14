abstract class ProgressRepository {
  Future<double> getCourseProgress(String courseId);
  Future<void> markLessonAsComplete(String courseId, String lessonId);
  Future<bool> isLessonCompleted(String courseId, String lessonId);
}

import 'lesson.dart';
import 'live_session.dart';

class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;
  final LiveSession? liveSession;

  Module({
    required this.id,
    required this.title,
    required this.lessons,
    this.liveSession,
  });
}

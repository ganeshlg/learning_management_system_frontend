import 'lesson.dart';
import 'live_session.dart';

class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;
  final String? videoUrl;
  final String? type;
  final String? liveLink;
  final String? recordedVideoUrl;
  final LiveSession? liveSession;

  Module({
    required this.id,
    required this.title,
    required this.lessons,
    this.videoUrl,
    this.type,
    this.liveLink,
    this.recordedVideoUrl,
    this.liveSession,
  });
}

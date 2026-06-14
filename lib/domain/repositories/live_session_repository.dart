import '../entities/live_session.dart';

abstract class LiveSessionRepository {
  Future<LiveSession?> getLiveSession(String sessionId);
}

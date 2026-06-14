import '../../domain/entities/live_session.dart';
import '../../domain/repositories/live_session_repository.dart';

class MockLiveSessionRepository implements LiveSessionRepository {
  @override
  Future<LiveSession?> getLiveSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return LiveSession(
      id: sessionId,
      title: 'Deep Dive into Project Financing',
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
      joinUrl: 'https://zoom.us/j/mock_meeting_id',
    );
  }
}

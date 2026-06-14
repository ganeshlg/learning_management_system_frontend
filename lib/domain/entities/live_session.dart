class LiveSession {
  final String id;
  final String title;
  final DateTime scheduledAt;
  final String? joinUrl;
  final String? recordingUrl;
  final String? notes;
  final bool isCompleted;

  LiveSession({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.joinUrl,
    this.recordingUrl,
    this.notes,
    this.isCompleted = false,
  });
}

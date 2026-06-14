import 'answer.dart';

class Question {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;
  final List<Answer> answers;
  final DateTime? expiresAt;

  Question({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
    this.answers = const [],
    this.expiresAt,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

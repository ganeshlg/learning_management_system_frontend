import 'resource.dart';

enum LessonType { recorded, live }

class Lesson {
  final String id;
  final String title;
  final LessonType type;
  final String? notes;
  final List<Resource> resources;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    this.notes,
    this.resources = const [],
    this.isCompleted = false,
  });
}

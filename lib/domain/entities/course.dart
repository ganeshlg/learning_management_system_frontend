import 'module.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final double price;
  final Duration duration;
  final List<Module> modules;
  final String instructorName;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.price,
    required this.duration,
    required this.modules,
    required this.instructorName
  });
}

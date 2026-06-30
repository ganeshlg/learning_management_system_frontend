import '../../../domain/entities/course.dart';
import '../../../domain/entities/module.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/resource.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../network/network_manager.dart';

class RemoteCourseRepository extends CourseRepository {
  // Caching futures to prevent redundant API calls
  Future<List<Course>>? _allCoursesFuture;
  final Map<String, Future<List<String>>> _purchasedIdsFutures = {};

  @override
  Future<List<Course>> getAvailableCourses() async {
    final authResponse = await getIt<AuthRepository>().getCurrentUser();
    final email = authResponse?.user?.email;

    final allCourses = await _getAllCourses();
    
    if (email == null) return allCourses;

    final purchasedIds = await _getPurchasedIds(email);
    
    // Return only courses that are NOT in the purchased list
    return allCourses.where((course) => !purchasedIds.contains(course.id)).toList();
  }

  @override
  Future<Course?> getCourseById(String id) async {
    return await getIt<NetworkManager>().get<Course?>(
      path: '/courses/$id',
      converter: (json) {
        if (json['course'] == null) return null;
        return _mapCourse(json['course']);
      },
    );
  }

  @override
  Future<List<Course>> getPurchasedCourses() async {
    final authResponse = await getIt<AuthRepository>().getCurrentUser();
    final email = authResponse?.user?.email;

    if (email == null) return [];

    final purchasedIds = await _getPurchasedIds(email);
    if (purchasedIds.isEmpty) return [];

    final allCourses = await _getAllCourses();

    // Return only courses that ARE in the purchased list
    return allCourses.where((course) => purchasedIds.contains(course.id)).toList();
  }

  @override
  Future<void> purchaseCourse(String id) async {
    final authResponse = await getIt<AuthRepository>().getCurrentUser();
    final email = authResponse?.user?.email;

    await getIt<NetworkManager>().post(
      path: '/purchase',
      body: {
        'email': email,
        'course_id': id,
      },
      converter: (json) => json,
    );

    // Invalidate the purchases cache for this user
    if (email != null) {
      _purchasedIdsFutures.remove(email);
    }
  }

  // Private Helper Methods with Future-based caching
  
  Future<List<Course>> _getAllCourses() {
    _allCoursesFuture ??= getIt<NetworkManager>().get<List<Course>>(
      path: '/courses',
      converter: (json) {
        final List<dynamic> coursesJson = json['courses'] ?? [];
        return coursesJson.map((item) => _mapCourse(item)).toList();
      },
    );
    return _allCoursesFuture!;
  }

  Future<List<String>> _getPurchasedIds(String email) {
    _purchasedIdsFutures[email] ??= getIt<NetworkManager>().get<List<String>>(
      path: '/purchases',
      queryParameters: {'email': email},
      converter: (json) {
        final List<dynamic> ids = json['course_ids'] ?? [];
        return ids.map((id) => id.toString()).toList();
      },
    );
    return _purchasedIdsFutures[email]!;
  }

  Course _mapCourse(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Course',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? 'https://via.placeholder.com/300x200?text=No+Thumbnail',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: Duration(
        hours: double.tryParse(json['duration_hours']?.toString() ?? '0')?.toInt() ?? 0,
      ),
      instructorName: json['instructor_name'] ?? 'Unknown Instructor',
      modules: (json['modules'] as List?)
              ?.map((m) => _mapModule(m))
              .toList() ??
          [],
    );
  }

  Module _mapModule(Map<String, dynamic> json) {
    return Module(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Module',
      videoUrl: json['video_url'],
      lessons: (json['lessons'] as List?)
              ?.map((l) => _mapLesson(l))
              .toList() ??
          [],
    );
  }

  Lesson _mapLesson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Lesson',
      type: json['lesson_type'] == 'live' ? LessonType.live : LessonType.recorded,
      notes: json['notes'] ?? json['content'], // Fallback to content if notes is null
      resources: (json['resources'] as List?)
              ?.map((r) => _mapResource(r))
              .toList() ??
          [],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Resource _mapResource(Map<String, dynamic> json) {
    return Resource(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Resource',
      url: json['url'] ?? '',
      type: _mapResourceType(json['file_type']?.toString() ?? ''),
    );
  }

  ResourceType _mapResourceType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return ResourceType.pdf;
      case 'excel':
      case 'xlsx':
      case 'csv':
        return ResourceType.excel;
      case 'ppt':
      case 'pptx':
        return ResourceType.ppt;
      default:
        return ResourceType.other;
    }
  }
}

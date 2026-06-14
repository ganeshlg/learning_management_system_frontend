import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Added import
import '../../../domain/entities/course.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseId;

  const CourseDetailsPage({super.key, required this.courseId});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late Future<Course?> _courseFuture;
  Lesson? _selectedLesson;
  VideoPlayerController? _videoController;
  bool noVideoAvailable = false;

  @override
  void initState() {
    super.initState();
    _courseFuture = getIt<CourseRepository>()
        .getCourseById(widget.courseId)
        .then((course) {
          if (course != null &&
              course.modules.isNotEmpty &&
              course.modules[0].lessons.isNotEmpty) {
            setState(() {
              _selectedLesson = course.modules[0].lessons[0];
              _initializeVideo(
                _selectedLesson?.videoUrl,
              ); // Initialize first video
            });
          }
          return course;
        });
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Clean up controller
    super.dispose();
  }

  // Helper to handle Google Drive URLs and initialize player
  void _initializeVideo(String? url) async {
    await _videoController?.dispose();
    _videoController = null;

    if (url == null || url.isEmpty) {
      noVideoAvailable = true;
      setState(() {});
      return;
    }

    // Convert Drive preview link to direct stream link if necessary
    final directUrl = _convertDriveUrl(url);

    _videoController = VideoPlayerController.networkUrl(Uri.parse(directUrl))
      ..initialize().then((_) {
        setState(() {}); // Refresh to show video player
      });
  }

  String _convertDriveUrl(String url) {
    if (url.contains('drive.google.com')) {
      final RegExp regExp = RegExp(r'\/d\/([^\/]+)');
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Content')),
      body: FutureBuilder<Course?>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final course = snapshot.data;
          if (course == null) {
            return const Center(child: Text('Course not found'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                // Desktop/Tablet Layout
                return Row(
                  children: [
                    SizedBox(width: 300, child: _buildSidebar(course)),
                    const VerticalDivider(width: 1),
                    Expanded(child: _buildContentArea()),
                  ],
                );
              } else {
                // Mobile Layout
                return Column(
                  children: [
                    Expanded(child: _buildContentArea()),
                    const Divider(height: 1),
                    SizedBox(height: 200, child: _buildSidebar(course)),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSidebar(Course course) {
    return ListView.builder(
      itemCount: course.modules.length,
      itemBuilder: (context, index) {
        final module = course.modules[index];
        return ExpansionTile(
          initiallyExpanded: index == 0,
          title: Text(
            module.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: module.lessons.map((lesson) {
            return ListTile(
              selected: _selectedLesson?.id == lesson.id,
              title: Text(lesson.title),
              leading: Icon(
                lesson.isCompleted
                    ? Icons.check_circle
                    : Icons.play_circle_outline,
                color: lesson.isCompleted ? Colors.green : null,
              ),
              onTap: () {
                if (_selectedLesson?.id != lesson.id) {
                  setState(() {
                    _selectedLesson = lesson;
                    _initializeVideo(
                      lesson.videoUrl,
                    ); // Update video on lesson change
                  });
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildContentArea() {
    if (_selectedLesson == null) {
      return const Center(child: Text('Select a lesson to start learning'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VideoStabilizer(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child:
                    _videoController != null &&
                        _videoController!.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _videoController!.value.isPlaying
                                ? _videoController!.pause()
                                : _videoController!.play();
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_videoController!),
                            if (!_videoController!.value.isPlaying)
                              const Icon(
                                Icons.play_arrow,
                                size: 80,
                                color: Colors.white70,
                              ),
                          ],
                        ),
                      )
                    : noVideoAvailable
                    ? Center(child: Text('No Video Available!', style: TextStyle(color: Colors.white),))
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedLesson!.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lesson Notes:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedLesson!.notes ??
                'In this lesson, we will cover the core concepts of ${_selectedLesson!.title}. Follow along with the provided resources.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text(
            'Resources:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              ActionChip(
                avatar: const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('Lecture_Notes.pdf'),
                onPressed: () {},
              ),
              ActionChip(
                avatar: const Icon(Icons.table_chart, size: 16),
                label: const Text('Project_Template.xlsx'),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check),
              label: const Text('Mark as Complete'),
            ),
          ),
        ],
      ),
    );
  }
}

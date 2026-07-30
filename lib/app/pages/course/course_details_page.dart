import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../data/network/network_manager.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/module.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/resource.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/repositories/progress_repository.dart';
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
  Module? _selectedModule;
  Lesson? _selectedLesson;
  VideoPlayerController? _videoController;
  String? _currentVideoUrl;
  bool noVideoAvailable = false;
  final Map<String, bool> _lessonCompletionStatus = {};

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  void _loadCourse() {
    final courseRepo = getIt<CourseRepository>();

    _courseFuture = courseRepo.getCourseById(widget.courseId).then((course) async {
      if (course != null) {
        // Load initial completion status for all lessons in the course
        for (var module in course.modules) {
          for (var lesson in module.lessons) {
            final completed = await getIt<ProgressRepository>()
                .isLessonCompleted(course.id, lesson.id);
            _lessonCompletionStatus[lesson.id] = completed;
          }
        }

        setState(() {
          // Find the first module that actually has lessons
          final firstModuleWithLessons = course.modules.cast<Module?>().firstWhere(
                (m) => m != null && m.lessons.isNotEmpty,
                orElse: () => null,
              );

          if (firstModuleWithLessons != null) {
            _selectedModule = firstModuleWithLessons;
            _selectedLesson = null;
            _currentVideoUrl = firstModuleWithLessons.videoUrl;
            _initializeVideo(_currentVideoUrl); // Initialize module video
          }
        });
      }
      return course;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideo(String? url) async {
    await _videoController?.dispose();
    _videoController = null;

    if (url == null || url.isEmpty) {
      setState(() {
        noVideoAvailable = true;
      });
      return;
    }

    setState(() {
      noVideoAvailable = false;
    });

    final directUrl = _convertDriveUrl(url);

    _videoController = VideoPlayerController.networkUrl(Uri.parse(directUrl))
      ..initialize().then((_) {
        setState(() {});
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

  IconData _getResourceIcon(ResourceType type) {
    switch (type) {
      case ResourceType.pdf:
        return Icons.picture_as_pdf;
      case ResourceType.excel:
        return Icons.table_chart;
      case ResourceType.ppt:
        return Icons.slideshow;
      case ResourceType.other:
      default:
        return Icons.insert_drive_file;
    }
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
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 300, child: _buildSidebar(course)),
                    const VerticalDivider(width: 1),
                    Expanded(child: _buildContentArea()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: 250, child: _buildSidebar(course)),
                    const Divider(height: 1),
                    Expanded(child: _buildContentArea()),
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
    // Only display modules that have lessons
    final modulesWithLessons =
        course.modules.where((m) => m.lessons.isNotEmpty).toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: modulesWithLessons.length,
      itemBuilder: (context, index) {
        final module = modulesWithLessons[index];
        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          childrenPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          initiallyExpanded: index == 0,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          onExpansionChanged: (expanded) {
            if (expanded) {
              setState(() {
                _selectedModule = module;
                _selectedLesson = null;
                if (_currentVideoUrl != module.videoUrl) {
                  _currentVideoUrl = module.videoUrl;
                  _initializeVideo(_currentVideoUrl);
                }
              });
            }
          },
          title: Text(
            module.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  _selectedModule?.id == module.id && _selectedLesson == null
                      ? Theme.of(context).primaryColor
                      : null,
            ),
          ),
          children:
              module.lessons.map((lesson) {
                final isCompleted = _lessonCompletionStatus[lesson.id] ?? false;
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                  selected: _selectedLesson?.id == lesson.id,
                  title: Text(lesson.title),
                  leading: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.play_circle_outline,
                    color: isCompleted ? Colors.green : null,
                  ),
                  onTap: () {
                    if (_selectedLesson?.id != lesson.id) {
                      setState(() {
                        _selectedLesson = lesson;
                        _selectedModule = module;
                      });
                    }
                  },
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildLiveLinkCard(String url) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Theme.of(context).primaryColor.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.live_tv, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text(
              'Live Session',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The instructor is currently hosting a live session. Click the button below to join the meeting.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => getIt<NetworkManager>().downloadFile(url),
                icon: const Icon(Icons.videocam),
                label: const Text('JOIN NOW'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea() {
    if (_selectedModule == null && _selectedLesson == null) {
      return const Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Select a module or lesson to start learning'),
        ),
      );
    }

    final displayTitle = _selectedLesson?.title ?? _selectedModule?.title ?? '';
    final displayNotes =
        _selectedLesson?.notes ??
        (_selectedModule != null
            ? "Select a lesson from the sidebar to view its content."
            : "");

    return SingleChildScrollView(
      key: ValueKey(_selectedLesson?.id ?? _selectedModule?.id),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedLesson == null) ...[
            if (_selectedModule?.videoUrl != null &&
                _selectedModule!.videoUrl!.isNotEmpty) ...[
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
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ] else if (_selectedModule?.type == 'live' &&
                _selectedModule?.liveLink != null &&
                _selectedModule!.liveLink!.isNotEmpty) ...[
              _buildLiveLinkCard(_selectedModule!.liveLink!),
              const SizedBox(height: 24),
            ] else ...[
              VideoStabilizer(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        'No Video Available!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
          Text(
            displayTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (_selectedLesson != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Lesson Notes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              displayNotes,
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
              runSpacing: 8,
              children:
                  _selectedLesson!.resources.map((resource) {
                    return ActionChip(
                      avatar: Icon(_getResourceIcon(resource.type), size: 16),
                      label: Text(resource.title),
                      onPressed: () {
                        // use dio to download the file.
                        getIt<NetworkManager>().downloadFile(resource.url);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${resource.title}...'),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: (_lessonCompletionStatus[_selectedLesson!.id] ?? false)
                    ? null
                    : () async {
                        await getIt<ProgressRepository>().markLessonAsComplete(
                          widget.courseId,
                          _selectedLesson!.id,
                        );
                        setState(() {
                          _lessonCompletionStatus[_selectedLesson!.id] = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lesson marked as complete!')),
                        );
                      },
                icon: const Icon(Icons.check),
                label: Text(
                  (_lessonCompletionStatus[_selectedLesson!.id] ?? false)
                      ? 'Completed'
                      : 'Mark as Complete',
                ),
              ),
            ),
          ] else if (_selectedModule != null) ...[
            const SizedBox(height: 16),
            Text(displayNotes, style: const TextStyle(fontSize: 16)),
          ],
        ],
      ),
    );
  }
}

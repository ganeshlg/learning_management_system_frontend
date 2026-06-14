import 'package:flutter/material.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';

class CourseSummaryPage extends StatelessWidget {
  final String courseId;
  const CourseSummaryPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Summary'),
      ),
      body: FutureBuilder<Course?>(
        future: getIt<CourseRepository>().getCourseById(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final course = snapshot.data;
          if (course == null) {
            return const Center(child: Text('Course not found'));
          }

          return SingleChildScrollView(
            child: ScreenStabilizer(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompletionBanner(context),
                    const SizedBox(height: 32),
                    _buildProgressSection(context),
                    const SizedBox(height: 32),
                    _buildResourcesSection(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletionBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, size: 80, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'Congratulations!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Text('You have successfully completed the course.'),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Final Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        const LinearProgressIndicator(value: 1.0, minHeight: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
        const SizedBox(height: 8),
        const Text('100% Completed', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Course Resources', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        _buildResourceGroup(context, 'Recordings', Icons.video_library, ['Session 1 Recording', 'Session 2 Recording']),
        _buildResourceGroup(context, 'Documents', Icons.description, ['Business Plan Template.pdf', 'Budgeting.xlsx']),
        _buildResourceGroup(context, 'Assignments', Icons.assignment, ['Final Project Submission']),
      ],
    );
  }

  Widget _buildResourceGroup(BuildContext context, String title, IconData icon, List<String> items) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: items
          .map((item) => ListTile(
                title: Text(item),
                trailing: const Icon(Icons.download),
                onTap: () {},
              ))
          .toList(),
    );
  }
}

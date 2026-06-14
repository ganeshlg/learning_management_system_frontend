import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/repositories/progress_repository.dart';
import '../../../domain/services/service_locator.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.name});

  final String name;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Course>> _purchasedCoursesFuture;
  late Future<List<Course>> _availableCoursesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final courseRepo = getIt<CourseRepository>();
    _purchasedCoursesFuture = courseRepo.getPurchasedCourses();
    _availableCoursesFuture = courseRepo.getAvailableCourses();
  }

  void _refreshCourses() {
    setState(() {
      _loadData();
    });
  }

  void _showRazorpayMock(Course course) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MockRazorpayDialog(
        course: course,
        onSuccess: () async {
          await getIt<CourseRepository>().purchaseCourse(course.id);
          _refreshCourses();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully purchased ${course.title}!'),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: ScreenStabilizer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Welcome back, ${widget.name}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, 'Your Courses'),
              const SizedBox(height: 16),
              _buildPurchasedCourses(),
              const SizedBox(height: 32),
              _buildSectionHeader(context, 'Explore Courses'),
              const SizedBox(height: 16),
              _buildAvailableCourses(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPurchasedCourses() {
    return FutureBuilder<List<Course>>(
      future: _purchasedCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading courses'));
        }
        final courses = snapshot.data ?? [];
        if (courses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('You haven\'t purchased any courses yet.'),
          );
        }
        return SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final course = courses[index];
              return _PurchasedCourseCard(course: course);
            },
          ),
        );
      },
    );
  }

  Widget _buildAvailableCourses() {
    return FutureBuilder<List<Course>>(
      future: _availableCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final courses = snapshot.data ?? [];
        if (courses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Great! You\'ve purchased all currently available courses. There are no more courses to explore at the moment. You can find all your purchased courses in the top section.',
            ),
          );
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _AvailableCourseCard(
                    course: course,
                    onBuy: () => _showRazorpayMock(course),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class _PurchasedCourseCard extends StatefulWidget {
  final Course course;

  const _PurchasedCourseCard({required this.course});

  @override
  State<_PurchasedCourseCard> createState() => _PurchasedCourseCardState();
}

class _PurchasedCourseCardState extends State<_PurchasedCourseCard> {
  late Future<double> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = getIt<ProgressRepository>().getCourseProgress(
      widget.course.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/course/${widget.course.id}'),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: widget.course.thumbnailUrl.startsWith('http')
                ? NetworkImage(widget.course.thumbnailUrl) as ImageProvider
                : AssetImage(widget.course.thumbnailUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.course.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            FutureBuilder<double>(
              future: _progressFuture,
              builder: (context, snapshot) {
                final progress = snapshot.data ?? 0.0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(
                        Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toInt()}% Complete',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailableCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onBuy;

  const _AvailableCourseCard({required this.course, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: course.thumbnailUrl.startsWith('http')
                ? Image.network(
                    course.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Image.asset(
                    course.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  course.instructorName,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${course.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onBuy,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Buy Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockRazorpayDialog extends StatefulWidget {
  final Course course;
  final VoidCallback onSuccess;

  const _MockRazorpayDialog({required this.course, required this.onSuccess});

  @override
  State<_MockRazorpayDialog> createState() => _MockRazorpayDialogState();
}

class _MockRazorpayDialogState extends State<_MockRazorpayDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.payment, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Razorpay Checkout'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.course.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Amount to pay: ₹${widget.course.price.toStringAsFixed(0)}'),
          const SizedBox(height: 24),
          if (_isProcessing)
            const Center(child: CircularProgressIndicator())
          else
            const Text('Simulating secure payment gateway...'),
        ],
      ),
      actions: [
        if (!_isProcessing) ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() => _isProcessing = true);
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) {
                widget.onSuccess();
                Navigator.pop(context);
              }
            },
            child: const Text('Pay Now'),
          ),
        ],
      ],
    );
  }
}

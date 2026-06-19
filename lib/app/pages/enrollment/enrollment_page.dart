import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/screen_stabilizer/screen_stabilizer.dart';

class EnrollmentPage extends StatelessWidget {
  const EnrollmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(),
            _BenefitsSection(),
            _CourseOutcomes(),
            // _Testimonials(),
            _FAQSection(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        image: DecorationImage(
          image: const AssetImage('assets/cover_image.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
            BlendMode.multiply,
          ),
        ),
      ),
      child: ScreenStabilizer(
        child: Column(
          children: [
            Text(
              'Civil Entrepreneurship',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Build your own civil engineering business from scratch. Master the skills that matter.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/auth'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text('Enroll Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: ScreenStabilizer(
        child: Column(
          children: [
            Text(
              'Why Join Us?',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount =
                constraints.maxWidth > 900
                    ? 4
                    : (constraints.maxWidth > 600 ? 2 : 1);

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.9,
                  children: const [
                    _BenefitCard(
                      icon: Icons.lightbulb,
                      title: 'Entrepreneurship Skills',
                      description:
                      'Develop practical leadership, problem-solving, and business-building skills.',
                    ),
                    _BenefitCard(
                      icon: Icons.trending_up,
                      title: 'Business Growth',
                      description:
                      'Learn strategies to scale your business and create sustainable growth.',
                    ),
                    _BenefitCard(
                      icon: Icons.engineering,
                      title: 'Industry Knowledge',
                      description:
                      'Gain insights into emerging trends, technologies, and best practices.',
                    ),
                    _BenefitCard(
                      icon: Icons.people,
                      title: 'Networking',
                      description:
                      'Connect with entrepreneurs, mentors, investors, and industry experts.',
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

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _CourseOutcomes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: ScreenStabilizer(
        child: Column(
          children: [
            Text('Course Outcomes', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 40),
            const _OutcomeItem(number: '01', text: 'Define your business niche'),
            const _OutcomeItem(number: '02', text: 'Master client acquisition'),
            const _OutcomeItem(number: '03', text: 'Understand financial management'),
            const _OutcomeItem(number: '04', text: 'Scale your operations'),
          ],
        ),
      ),
    );
  }
}

class _OutcomeItem extends StatelessWidget {
  final String number;
  final String text;
  const _OutcomeItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(child: Text(number)),
          const SizedBox(width: 20),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}

class _Testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: ScreenStabilizer(
        child: Column(
          children: [
            Text('Testimonials', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 40),
            const SizedBox(
              height: 200,
              child: Center(child: Text('Carousel Placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: ScreenStabilizer(
        child: Column(
          children: [
            Text('FAQ', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 40),
            const ExpansionTile(title: Text('Who is this course for?'), children: [Padding(padding: EdgeInsets.all(16), child: Text('Civil engineers looking to start their own business.'))]),
            const ExpansionTile(title: Text('Is there a certificate?'), children: [Padding(padding: EdgeInsets.all(16), child: Text('Yes, upon successful completion.'))]),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: ScreenStabilizer(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Contact'),
                Text('Privacy'),
                Text('Terms'),
              ],
            ),
            const SizedBox(height: 20),
            Text('© 2026 Civil Entrepreneurship. All rights reserved.', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

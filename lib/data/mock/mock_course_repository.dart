import '../../domain/entities/course.dart';
import '../../domain/entities/module.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/course_repository.dart';

class MockCourseRepository implements CourseRepository {
  final List<Course> _courses = [
    Course(
      id: '1',
      title: 'Civil Entrepreneurship Masterclass',
      description:
          'Learn how to start and scale your civil engineering business.',
      thumbnailUrl:
          'assets/course_image_1.png',
      price: 10000,
      duration: const Duration(hours: 100),
      instructorName: 'Er. Ganesh R',
      modules: [
        Module(
          id: 'm1',
          title: 'Introduction to Entrepreneurship',
          videoUrl: "https://learning- management-system-api-gateway-v1.onrender.com/api/videos/civil.mp4",
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Difference between Engineer vs Entrepreneur',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Why Civil Engineers are naturally suited for business',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Risk-taking and decision-making',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Building confidence and leadership',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Entrepreneurial habits and discipline',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title:
                  'Case studies of successful civil engineering entrepreneurs',
              type: LessonType.recorded,
            ),
          ],
        ),
        Module(
          id: 'm2',
          title: 'Business Opportunities in Civil Engineering',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Construction contracting',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Project management consultancy',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Quantity surveying',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Interior fit-outs',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Infrastructure projects',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Real estate development',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Sustainable construction',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'EPC contracts (Turnkey Contracts)',
              type: LessonType.recorded,
            ),
            Lesson(id: 'l9', title: 'BIM services', type: LessonType.recorded),
            Lesson(
              id: 'l10',
              title: 'Construction technology',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l11',
              title: 'Choosing niche vs general contracting',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l12',
              title: 'Market demand analysis',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l13',
              title: 'Identifying gaps in local markets',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm3',
          title: 'Business Model Development',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Business model canvas',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Service-based vs asset-based business',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Revenue streams',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Cost structures',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Pricing strategies',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Value proposition creation',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Competitive positioning',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm4',
          title: 'Legal, Registration and Compliances',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Sole proprietorship vs partnership vs LLP vs Pvt Ltd',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'GST registration',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'MSME registration',
              type: LessonType.recorded,
            ),
            Lesson(id: 'l4', title: 'Labour laws', type: LessonType.recorded),
            Lesson(
              id: 'l5',
              title: 'Contractor licenses',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Professional tax',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Income tax basics',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Tender eligibility documentation',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l9',
              title: 'Agreements and contracts',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm5',
          title: 'Finance for Construction Entrepreneurs',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Understanding cash flow',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Working capital management',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Project budgeting',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Estimation and costing',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'BOQ preparation',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Profit margin calculation',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Funding options',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Bank loans and project finance',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l9',
              title: 'Financial mistakes in construction business',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm6',
          title: 'Tendering and Business Development',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Government tendering process',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Private contracts',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Vendor registrations',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Proposal preparation',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Estimation strategies',
              type: LessonType.recorded,
            ),
            Lesson(id: 'l6', title: 'Bid analysis', type: LessonType.recorded),
            Lesson(
              id: 'l7',
              title: 'Networking and relationship building',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Marketing for engineering businesses',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l9',
              title: 'Digital branding and LinkedIn presence',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm7',
          title: 'Project Execution and Operations',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Site management systems',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Resource planning',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Vendor and subcontractor management',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Quality control',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Time management',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Construction scheduling',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Risk management',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Safety systems',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l9',
              title: 'Handling delays and disputes',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm8',
          title: 'Team Building and Leadership',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Hiring engineers and site staff',
              type: LessonType.recorded,
            ),
            Lesson(id: 'l2', title: 'Delegation', type: LessonType.recorded),
            Lesson(id: 'l3', title: 'Team culture', type: LessonType.recorded),
            Lesson(
              id: 'l4',
              title: 'Communication skills',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Conflict resolution',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Negotiation skills',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Client management',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Leadership during crises',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm9',
          title: 'Technology and Innovation in Construction',
          lessons: [
            Lesson(id: 'l1', title: 'BIM', type: LessonType.recorded),
            Lesson(
              id: 'l2',
              title: 'AI in construction',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Drones and surveying technology',
              type: LessonType.recorded,
            ),
            Lesson(id: 'l4', title: 'ERP systems', type: LessonType.recorded),
            Lesson(
              id: 'l5',
              title: 'Construction automation',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Sustainable construction',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Smart buildings',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Green certifications',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm10',
          title: 'Scaling the Business',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'Scaling from small contractor to enterprise',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Systems and SOPs',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Expanding geographically',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Joint ventures',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Building recurring revenue',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Creating multiple business verticals',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l7',
              title: 'Wealth creation through real estate',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l8',
              title: 'Exit strategies',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm11',
          title: 'Personal Branding and Marketing Techniques',
          lessons: [
            Lesson(
              id: 'l1',
              title: 'LinkedIn branding',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l2',
              title: 'Public speaking',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Networking with developers and consultants',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Creating authority in the market',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Content marketing',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l6',
              title: 'Building trust and credibility',
              type: LessonType.recorded,
            ),
          ],
        ),

        Module(
          id: 'm12',
          title: 'Capstone Project',
          lessons: [
            Lesson(id: 'l1', title: 'Business plan', type: LessonType.recorded),
            Lesson(
              id: 'l2',
              title: 'Financial plan',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l3',
              title: 'Market strategy',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l4',
              title: 'Execution roadmap',
              type: LessonType.recorded,
            ),
            Lesson(
              id: 'l5',
              title: 'Growth strategy',
              type: LessonType.recorded,
            ),
          ],
        ),
      ],
    ),
    Course(
      id: '2',
      title: 'Advanced Construction Management',
      description: 'Master the tools and techniques of modern construction management.',
      thumbnailUrl:
      'assets/course_image_2.png',
      price: 2999,
      duration: const Duration(hours: 15),
      instructorName: 'Er. S. Lakshmi',
      modules: [],
    ),
  ];

  final List<String> _purchasedCourseIds = [];

  @override
  Future<List<Course>> getAvailableCourses() async {
    // await Future.delayed(const Duration(milliseconds: 500));
    List<Course> courses = [];
    return _courses.where((c) => !_purchasedCourseIds.contains(c.id)).toList();
  }

  @override
  Future<List<Course>> getPurchasedCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _courses.where((c) => _purchasedCourseIds.contains(c.id)).toList();
  }

  @override
  Future<Course?> getCourseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _courses.firstWhere((c) => c.id == id);
  }

  @override
  Future<void> purchaseCourse(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_purchasedCourseIds.contains(id)) {
      _purchasedCourseIds.add(id);
    }
  }
}

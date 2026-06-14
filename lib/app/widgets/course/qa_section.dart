import 'package:flutter/material.dart';
import '../../../domain/entities/question.dart';
import '../../../domain/entities/answer.dart';

class QASection extends StatefulWidget {
  final String sessionId;
  const QASection({super.key, required this.sessionId});

  @override
  State<QASection> createState() => _QASectionState();
}

class _QASectionState extends State<QASection> {
  final List<Question> _mockQuestions = [
    Question(
      id: 'q1',
      userId: 'u1',
      userName: 'Alice',
      content: 'Can you explain the difference between a tender and a contract?',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      answers: [
        Answer(
          id: 'a1',
          userId: 'i1',
          userName: 'Instructor',
          content: 'A tender is an invitation to bid, while a contract is the legally binding agreement after the bid is accepted.',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ],
      expiresAt: DateTime.now().add(const Duration(days: 29)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Q&A Section', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search),
              label: const Text('Search'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mockQuestions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final question = _mockQuestions[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(question.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(question.content),
                  trailing: Text('${question.createdAt.day}/${question.createdAt.month}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Column(
                    children: question.answers.map((answer) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(answer.userName, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                        subtitle: Text(answer.content),
                      );
                    }).toList(),
                  ),
                ),
                if (!question.isExpired)
                  TextButton(
                    onPressed: () {},
                    child: const Text('Reply'),
                  ),
                if (question.isExpired)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Thread closed (Read-only)', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            hintText: 'Ask a question...',
            suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

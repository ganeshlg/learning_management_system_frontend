class Assignment {
  final String id;
  final String title;
  final String description;
  final String? attachmentUrl;
  final bool isSubmitted;
  final DateTime? submittedAt;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    this.attachmentUrl,
    this.isSubmitted = false,
    this.submittedAt,
  });
}

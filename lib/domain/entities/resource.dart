enum ResourceType { pdf, excel, ppt, other }

class Resource {
  final String id;
  final String title;
  final ResourceType type;
  final String url;

  Resource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
  });
}

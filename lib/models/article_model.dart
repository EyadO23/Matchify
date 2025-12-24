class Article {
  final String title;
  final String publishedAt;
  final String source;

  Article({
    required this.title,
    required this.publishedAt,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      source: json['source'] ?? '',
    );
  }
}

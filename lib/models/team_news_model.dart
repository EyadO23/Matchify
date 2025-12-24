import 'article_model.dart';

class TeamNews {
  final String team;
  final String summary;
  final List<Article> articles;

  TeamNews({required this.team, required this.summary, required this.articles});

  factory TeamNews.fromJson(Map<String, dynamic> json) {
    return TeamNews(
      team: json['team'],
      summary: json['summary'],
      articles:
          (json['articles'] as List).map((a) => Article.fromJson(a)).toList(),
    );
  }
}

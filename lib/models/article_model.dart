// class Article {
//   final String title;
//   final String publishedAt;
//   final String source;

//   Article({
//     required this.title,
//     required this.publishedAt,
//     required this.source,
//   });

//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       title: json['title'] ?? '',
//       publishedAt: json['publishedAt'] ?? '',
//       source: json['source'] ?? '',
//     );
//   }
// }
import 'dart:convert';

// موديل للخبر الواحد
class Article {
  final String title;
  final String publishedAt;
  final String source;
  final String url;
  final String imageUrl;
  final int teamId;
  final String teamName;
  final String teamLogo;

  Article({
    required this.title,
    required this.publishedAt,
    required this.source,
    required this.url,
    required this.imageUrl,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamLogo: json['team_logo'] ?? '',
    );
  }
}

// موديل الحزمة الكاملة
class TeamNews {
  final List<Article> articles;
  final int totalArticles;

  TeamNews({required this.articles, required this.totalArticles});

  factory TeamNews.fromJson(Map<String, dynamic> json) {
    var articlesJson = json['articles'] as List<dynamic>? ?? [];
    List<Article> articlesList =
        articlesJson.map((e) => Article.fromJson(e)).toList();

    return TeamNews(
      articles: articlesList,
      totalArticles: json['total_articles'] ?? 0,
    );
  }
}

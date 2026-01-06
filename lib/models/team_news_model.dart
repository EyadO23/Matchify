// // import 'article_model.dart';

// // class TeamNews {
// //   final String team;
// //   final String summary;
// //   final List<Article> articles;

// //   TeamNews({required this.team, required this.summary, required this.articles});

// //   factory TeamNews.fromJson(Map<String, dynamic> json) {
// //     return TeamNews(
// //       team: json['team'],
// //       summary: json['summary'],
// //       articles:
// //           (json['articles'] as List).map((a) => Article.fromJson(a)).toList(),
// //     );
// //   }
// // }
// import 'package:matchifiy/models/news_article.dart';

// // class TeamNews {
// //   final List<News> articles;

// //   TeamNews({required this.articles});

// //   factory TeamNews.fromJson(Map<String, dynamic> json) {
// //     return TeamNews(
// //       articles:
// //           (json['articles'] as List).map((e) => News.fromJson(e)).toList(),
// //     );
// //   }
// // }

// class TeamNews {
//   final String title;
//   final String publishedAt;
//   final String source;
//   final String url;
//   final String imageUrl;
//   final int teamId;
//   final String teamName;
//   final String teamLogo;

//   TeamNews({
//     required this.title,
//     required this.publishedAt,
//     required this.source,
//     required this.url,
//     required this.imageUrl,
//     required this.teamId,
//     required this.teamName,
//     required this.teamLogo,
//   });

//   factory TeamNews.fromJson(Map<String, dynamic> json) {
//     return TeamNews(
//       title: json['title'] ?? 'بدون عنوان',
//       publishedAt: json['publishedAt'] ?? '',
//       source: json['source'] ?? '',
//       url: json['url'] ?? '',
//       imageUrl: json['image_url'] ?? '',
//       teamId: json['team_id'] ?? 0,
//       teamName: json['team_name'] ?? 'غير معروف',
//       teamLogo: json['team_logo'] ?? '',
//     );
//   }
// }
// class TeamArticle {
//   final String title;
//   final String description;
//   final String publishedAt;
//   final String imageUrl;
//   final String url;
//   final int teamId;

//   TeamArticle({
//     required this.title,
//     required this.description,
//     required this.publishedAt,
//     required this.imageUrl,
//     required this.url,
//     required this.teamId,
//   });

//   factory TeamArticle.fromJson(Map<String, dynamic> json) {
//     return TeamArticle(
//       title: json['title'] ?? 'بدون عنوان',
//       description: json['description'] ?? '',
//       publishedAt: json['publishedAt'] ?? '',
//       imageUrl: json['image_url'] ?? '',
//       url: json['url'] ?? '',
//       teamId: json['team_id'],
//     );
//   }
// }
class TeamArticle {
  final int? teamId;
  final String? teamName; // <--- جديد
  final String? teamLogo; // <--- جديد
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? publishedAt;

  TeamArticle({
    this.teamId,
    this.teamName,
    this.teamLogo,
    this.title,
    this.description,
    this.imageUrl,
    this.publishedAt,
  });

  factory TeamArticle.fromJson(Map<String, dynamic> json) {
    return TeamArticle(
      teamId: json['team_id'],
      teamName: json['team_name'], // <--- جديد
      teamLogo: json['team_logo'], // <--- جديد
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      publishedAt: json['published_at'],
    );
  }
}

class TeamNews {
  final Team? team;
  final List<TeamArticle> articles;

  TeamNews({required this.team, required this.articles});

  factory TeamNews.fromJson(Map<String, dynamic> json) {
    final teamData = json['team'];
    final List articlesData = json['articles'] ?? [];
    return TeamNews(
      team: teamData != null ? Team.fromJson(teamData) : null,
      articles: articlesData.map((e) => TeamArticle.fromJson(e)).toList(),
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'غير معروف',
      logo: json['logo'] ?? '',
    );
  }
}

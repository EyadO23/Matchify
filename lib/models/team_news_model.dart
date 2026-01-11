class TeamArticle {
  final int? teamId;
  final String? teamName;
  final String? teamLogo;
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
      teamName: json['team_name'],
      teamLogo: json['team_logo'],
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

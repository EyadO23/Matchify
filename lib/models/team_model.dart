class Team {
  final int id;
  final String name;
  final String logoUrl;

  Team({required this.id, required this.name, required this.logoUrl});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['team_id'],
      name: json['team_name'] ?? json['name'] ?? '',
      logoUrl: json['logo_url'],
    );
  }
}

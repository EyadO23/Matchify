class VideoFilterModel {
  final String url;
  final String type;
  final String summaryType;
  final String? playerName;

  VideoFilterModel({
    required this.url,
    required this.type,
    required this.summaryType,
    this.playerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type,
      'summary_type': summaryType,
      'player_name': playerName,
    };
  }

  factory VideoFilterModel.fromJson(Map<String, dynamic> json) {
    return VideoFilterModel(
      url: json['url'],
      type: json['type'],
      summaryType: json['summary_type'],
      playerName: json['player_name'],
    );
  }
}

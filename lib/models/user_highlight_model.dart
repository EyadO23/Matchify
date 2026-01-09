class UserHighlight {
  final int videoId;
  final String path;

  UserHighlight({required this.videoId, required this.path});

  factory UserHighlight.fromJson(Map<String, dynamic> json) {
    return UserHighlight(
      videoId: json['video_id'],
      path: json['highlight_path'],
    );
  }
}

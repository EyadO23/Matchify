// class MatchifyResult {
//   final bool success;
//   final String status;
//   final List<Highlight> highlights;
//   final String storagePath;

//   MatchifyResult({
//     required this.success,
//     required this.status,
//     required this.highlights,
//     required this.storagePath,
//   });

//   factory MatchifyResult.fromJson(Map<String, dynamic> json) {
//     var highlightsList = json['result']['highlights'] as List;
//     return MatchifyResult(
//       success: json['success'],
//       status: json['status'],
//       storagePath: json['storage_path'],
//       highlights: highlightsList.map((i) => Highlight.fromJson(i)).toList(),
//     );
//   }
// }

// class Highlight {
//   final String clipName;
//   final String videoPath;
//   final List<List<dynamic>> segments;

//   Highlight({
//     required this.clipName,
//     required this.videoPath,
//     required this.segments,
//   });

//   factory Highlight.fromJson(Map<String, dynamic> json) {
//     return Highlight(
//       clipName: json['clip'],
//       videoPath: json['highlight_video'],
//       segments: List<List<dynamic>>.from(json['segments']),
//     );
//   }
// }
class MatchifyResult {
  final bool success;
  final String status;
  final List<HighlightClip> highlights;
  final String? storagePath;

  MatchifyResult({
    required this.success,
    required this.status,
    required this.highlights,
    this.storagePath,
  });

  factory MatchifyResult.fromJson(Map<String, dynamic> json) {
    var highlightsList = json['result']['highlights'] as List;
    return MatchifyResult(
      success: json['success'] ?? false,
      status: json['status'] ?? '',
      storagePath: json['storage_path'],
      highlights: highlightsList.map((i) => HighlightClip.fromJson(i)).toList(),
    );
  }
}

class HighlightClip {
  final String clip;
  final String highlightVideo;
  final List<List<dynamic>> segments;

  HighlightClip({
    required this.clip,
    required this.highlightVideo,
    required this.segments,
  });

  factory HighlightClip.fromJson(Map<String, dynamic> json) {
    return HighlightClip(
      clip: json['clip'],
      highlightVideo: json['highlight_video'],
      segments: List<List<dynamic>>.from(json['segments']),
    );
  }
}

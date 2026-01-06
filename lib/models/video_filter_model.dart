// class VideoFilterModel {
//   final int jobId;
//   final String status;
//   final List<dynamic> clips;

//   VideoFilterModel({
//     required this.jobId,
//     required this.status,
//     required this.clips,
//   });

//   factory VideoFilterModel.fromJson(Map<String, dynamic> json) {
//     return VideoFilterModel(
//       jobId: json['job_id'],
//       status: json['status'],
//       clips: json['clips'] ?? [],
//     );
//   }
// }
class VideoFilterModel {
  // معرف المهمة الفريد
  final int jobId;
  // حالة المهمة (قيد الانتظار، قيد المعالجة، مكتملة)
  final String status;
  // قائمة المقاطع المستخرجة من الفيديو
  final List<dynamic> clips;

  VideoFilterModel({
    required this.jobId,
    required this.status,
    required this.clips,
  });

  // تحويل البيانات القادمة من السيرفر (JSON) إلى كائن برمجى
  factory VideoFilterModel.fromJson(Map<String, dynamic> json) {
    return VideoFilterModel(
      jobId: json['job_id'] ?? 0,
      status: json['status'] ?? 'unknown',
      clips: json['clips'] ?? [],
    );
  }
}

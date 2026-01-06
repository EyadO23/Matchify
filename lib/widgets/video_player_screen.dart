// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(widget.videoUrl),
//     )..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(title: const Text("تشغيل اللقطة")),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:matchifiy/services/token_storage.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final token = await TokenStorage.getToken();

    _controller = VideoPlayerController.network(
      widget.videoUrl,
      httpHeaders: {"Authorization": "Bearer $token", "Accept": "video/mp4"},
    );

    try {
      print(_controller.dataSource);
      await _controller.initialize();
      _controller.play();
    } catch (e) {
      debugPrint("Video init error: $e");
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("تشغيل اللقطة"),
      ),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
      ),
      floatingActionButton:
          !_isLoading
              ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              )
              : null,
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/video_service.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   final VideoService _videoService = VideoService();
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initVideo();
//   }

//   Future<void> _initVideo() async {
//     try {
//       await _videoService.init(widget.videoUrl);
//     } catch (e) {
//       debugPrint("Video init error: $e");
//     }

//     if (mounted) setState(() => _isLoading = false);
//   }

//   @override
//   void dispose() {
//     _videoService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = _videoService.controller;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text("تشغيل اللقطة"),
//       ),
//       body: Center(
//         child: _isLoading || controller == null
//             ? const CircularProgressIndicator()
//             : AspectRatio(
//                 aspectRatio: controller.value.aspectRatio,
//                 child: VideoPlayer(controller),
//               ),
//       ),
//       floatingActionButton: !_isLoading && controller != null
//           ? FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   controller.value.isPlaying
//                       ? _videoService.pause()
//                       : _videoService.play();
//                 });
//               },
//               child: Icon(
//                 controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             )
//           : null,
//     );
//   }
// }

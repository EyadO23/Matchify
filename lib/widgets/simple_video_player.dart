import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const SimpleVideoPlayer({super.key, required this.videoUrl});

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // ملاحظة: تأكد أن الرابط يبدأ بـ http أو https ليعمل
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then(
        (_) => setState(() {
          _controller.play();
        }),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child:
          _controller.value.isInitialized
              ? Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed:
                        () => setState(
                          () =>
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play(),
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
              : const Center(
                child: CircularProgressIndicator(color: Color(0xFF7274E4)),
              ),
    );
  }
}

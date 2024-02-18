import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../util/images.dart';

class VideoCardWidget extends StatefulWidget {
  final String videoUrl;

  const VideoCardWidget({super.key, required this.videoUrl});

  @override
  _VideoCardWidgetState createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              left: 1,
              top: 1,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 60, color: Colors.white,),
                ),
              ),
            )
          ],);
        } else {
          return Image.asset(Images.placeholder,);
        }
      },
    );
  }

  @override
  void dispose() {
    // _videoPlayerController.dispose();
    // _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
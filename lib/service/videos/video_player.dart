import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPlatform extends StatefulWidget {
  VideoPlayerPlatform({Key key, this.pickedVideo}) : super(key: key);
  final File pickedVideo;

  @override
  _VideoPlayerPlatformState createState() => _VideoPlayerPlatformState();
}

class _VideoPlayerPlatformState extends State<VideoPlayerPlatform> {
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    print(widget.pickedVideo.path);
    _videoPlayerController = VideoPlayerController.file(widget.pickedVideo)
      ..addListener(() => setState(() {}))
      ..initialize().then((value) => _videoPlayerController.play());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: _videoPlayerController.value.isInitialized
              ? Stack(
                  children: [
                    buildVideoPlayer(),
                    Positioned.fill(
                        child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _videoPlayerController.value.isPlaying
                          ? _videoPlayerController.pause()
                          : _videoPlayerController.play(),
                      child: Stack(
                        children: [
                          _videoPlayerController.value.isPlaying
                              ? const SizedBox()
                              : Container(
                                  alignment: Alignment.center,
                                  color: Colors.black26,
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 80,
                                  )),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: VideoProgressIndicator(
                              _videoPlayerController,
                              allowScrubbing: true,
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ),
    );
  }

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      );

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}

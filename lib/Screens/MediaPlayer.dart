import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';

class MediaPlayer extends StatefulWidget {
  MediaPlayer(
      {this.controller,
      this.video,
      this.image,
      this.mediaType,
      this.playButtonVisible});

  final VideoPlayerController controller;
  final File video;
  final File image;
  final String mediaType;
  bool playButtonVisible = false;

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  @override
  Widget build(BuildContext context) {
    bool visible = true;

    void hideButton() {
      print("Hiding button...");
      setState(() {
        visible = false;
      });
    }

    void showButton() {
      print("Showing button...");
      setState(() {
        visible = true;
      });
    }

    return Column(children: [
      widget.mediaType == 'image'
          ? widget.image != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    width: 350,
                    child: Image.file(widget.image),
                  ),
                )
              : Text("Image is null")
          // : widget.video != null
          : widget.controller.value.initialized != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 350,
                        child: AspectRatio(
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: VideoPlayer(widget.controller),
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: Positioned(
                          left: 150,
                          top: 280,
                          child: Opacity(
                            opacity: 0.9,
                            child: FloatingActionButton(
                              backgroundColor: Colors.grey,
                              onPressed: () {
                                int duration =
                                    widget.controller.value.duration.inSeconds;
                                print("Duration: $duration");
                                setState(() {
                                  visible = !visible;
                                  if (widget.controller.value.initialized ==
                                      false) {
                                    print("controller is not initialized");
                                    widget.controller.initialize();
                                  } else if (widget
                                          .controller.value.isPlaying ==
                                      false) {
                                    print("Controller is not playing");
                                    // hideButton();
                                    widget.controller.initialize();
                                    widget.controller.play();
                                  } else {
                                    print("Controller is playing");
                                    // showButton();
                                    widget.controller.pause();
                                  }
                                  Timer(Duration(seconds: duration), () {
                                    print("Video is over");
                                    setState(() {
                                      widget.controller.pause();
                                    });
                                  });
                                });
                              },
                              child: Icon(
                                widget.controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Text("Controller not initialized")
      // : Text("Video is null"),
    ]);
  }
}

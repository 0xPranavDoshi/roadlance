import 'package:RoadLance/Components/DisplayBox.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './MediaPlayer.dart';
import '../Models/Post.dart';
import 'dart:async';

class PostDisplay extends StatefulWidget {
  PostDisplay({
    @required this.post,
  });

  final Post post;

  @override
  _PostDisplayState createState() => _PostDisplayState();
}

class _PostDisplayState extends State<PostDisplay> {
  List<Widget> mediaUrls = [];

  @override
  void initState() {
    super.initState();
    setMediaUrls();
  }

  Future setMediaUrls() async {
    int idx = 0;

    widget.post.mediaUrls.forEach((url) {
      if (url != null) {
        setState(() {
          mediaUrls.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: widget.post.mediaDetails[idx]['mediaType'] == 'image'
                  ? SizedBox(
                      width: 350,
                      child: Image.network(
                        url,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  : Text("Display video"),
            ),
          );
          idx += 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4b4266),
      appBar: AppBar(
        backgroundColor: Color(0xFF312c42),
        title: Text('Post'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Violation : ',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                      text: widget.post.violation,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: mediaUrls,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Description : ',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                      text: widget.post.description,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Number Plate : ',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                      text: widget.post.numberPlate,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Location : ',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                        text:
                            '(${widget.post.latitude.toStringAsFixed(2)}), (${widget.post.longitude.toStringAsFixed(2)})'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upload Time : ',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                        text: '${widget.post.uploadTime.toDate().toString()}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Status : ',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF070c29),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                widget.post.status,
                                style: TextStyle(
                                  color: Color(0xFF50fa7b),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                widget.post.status == 'Approved'
                                    ? Icons.check
                                    : Icons.error,
                                color: Color(0xFF50fa7b),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rtsp_ffmpeg/rtsp_ffmpeg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RtspVideoWidget(),
      ),
    );
  }
}

class RtspVideoWidget extends StatefulWidget {
  const RtspVideoWidget({super.key});

  @override
  State<RtspVideoWidget> createState() => _RtspVideoWidgetState();
}

class _RtspVideoWidgetState extends State<RtspVideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RtspFFMpeg(
          createdCallback: (_) async {
            await rtspController.play(rtspController.rtsp);
          },
        ),
        StreamBuilder(
          stream: videoAliveWatcherStream,
          builder: (context, snapshot) {
            return snapshot.data == false
                ? Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  )
                : SizedBox();
          },
        ),
      ],
    );
  }
}

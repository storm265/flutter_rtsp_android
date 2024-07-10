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
  late RtspController rtspController;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GestureDetector(
          child: RtspFFMpeg(
            createdCallback: (controller) async {
              await controller
                  .play('rtsp://192.168.65.122:8554/operator/h264/720p');
              // await controller.play('rtsp://192.168.65.122:8554/test');
            },
          ),
        ),
      ),
    );
  }
}

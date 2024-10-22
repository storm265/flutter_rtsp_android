import 'dart:async';
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
        body: GestureDetector(
          child: RtspFFMpeg(
            createdCallback: (controller) async {
              final streamWatchdogPrinter = Timer.periodic(
                  const Duration(milliseconds: 100),
                  (timer) =>
                      print("Stream is alive: ${controller.isStreamAlive}"));

              final rtsp = 'rtsp://192.168.65.122:8554/operator/h264/720p';
              await controller.play(rtsp);
              controller.streamAliveWatcher.listen((bool alive) async {
                if (alive) {
                  print("Stream is alive again");
                } else {
                  print("Stream is dead. Restarting...");
                  await controller.stop();
                  await controller.play(rtsp);
                }
              });

              // await controller.play('rtsp://192.168.65.122:8554/test');
            },
          ),
        ),
      ),
    );
  }
}

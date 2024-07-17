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
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GestureDetector(
          child: RtspFFMpeg(
            createdCallback: (controller) async {
              final streamWatchdogPrinter = Timer.periodic(
                  const Duration(milliseconds: 100), (timer) =>
                  print("Stream is alive: ${controller.isStreamAlive}")
              );
              await controller.play('rtsp://192.168.0.40:8554/test');
              // await controller.play('rtsp://192.168.65.122:8554/test');
            },
          ),
        ),
      ),
    );
  }
}

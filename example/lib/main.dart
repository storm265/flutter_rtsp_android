import 'dart:async';

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
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                await rtspController.stop();
                await rtspController.play(
                  "rtsp://192.168.65.122:8555/test",
                ); // rws url
              },
              child: Text('Set rws url'),
            ),
            ElevatedButton(
              onPressed: () async {
                await rtspController.stop();
                await rtspController.play(
                  "rtsp://192.168.65.122:8554/operator/h264/720p",
                ); // classic url
              },
              child: Text('Set classic url'),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: RtspFFMpeg(
          createdCallback: (controller) async {
            Timer.periodic(
              const Duration(milliseconds: 100),
              (timer) => print(
                "Stream is alive: ${controller.isStreamAlive}",
              ),
            );

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
          },
        ),
      ),
    );
  }
}

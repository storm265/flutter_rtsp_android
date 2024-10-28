import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String rtspUrl = 'rtsp://192.168.65.122:8554/operator/h264/720p';
final rtspController = RtspController(
  id: 0,
  rtspUrl: rtspUrl,
);

Stream<bool> videoAliveWatcherStream = Stream<bool>.periodic(
  Duration(milliseconds: 500),
  (computationCount) {
    debugPrint('is alive video: ${rtspController.isVideoAlive}');
    return rtspController.isVideoAlive;
  },
);

final class RtspController {
  RtspController({int id = 0, required String rtspUrl}) {
    _channel = MethodChannel('rtsp_ffmpeg$id');

    try {
      EventChannel('channel').receiveBroadcastStream().listen(
        (event) async {
          bool data = event as bool;

          isVideoAlive = data;

          if (!data) {
            debugPrint('restarting video');
            await stop();
            await play(rtspUrl);
          }
        },
      );
    } catch (e) {
      debugPrint('could listen stream alive channel');
    }
  }

  late MethodChannel _channel;

  late bool isVideoAlive;

  Future<void> play(String url) => _channel.invokeMethod('play', url);

  Future<void> stop() => _channel.invokeMethod('stop');

  Future<void> restartVideo() async {
    await stop();
    await play(rtspUrl);
  }
}

typedef RtspFFMpegCreatedCallback = void Function(RtspController controller);

class RtspFFMpeg extends StatefulWidget {
  final RtspFFMpegCreatedCallback createdCallback;

  const RtspFFMpeg({
    super.key,
    required this.createdCallback,
  });

  @override
  _RtspFFMpegState createState() => _RtspFFMpegState();
}

class _RtspFFMpegState extends State<RtspFFMpeg> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'rtsp_ffmpeg',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return Text('$defaultTargetPlatform is not yet supported by the plugin');
    }
  }

  void _onPlatformViewCreated(int id) {
    widget.createdCallback(rtspController);
  }
}

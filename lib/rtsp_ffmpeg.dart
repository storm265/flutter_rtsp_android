import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final rtspController = RtspController(0);

final class RtspController {
  static const watchdogPeriod = Duration(milliseconds: 200);

  RtspController(int id) {
    _channel = MethodChannel('rtsp_ffmpeg$id');
  }

  late MethodChannel _channel;

  // TODO: maybe./ /.;''
  //  >add Stream for this variable as well
  bool _isStreamAlive = false;

  late Future<void> _watchdog;

  Future<dynamic> play(String url) async {
    _isStreamAlive = true;
    final playFuture = _channel.invokeMethod('play', url);

    _watchdog = Future.doWhile(() async {
       await Future.delayed(watchdogPeriod);
       return await _channel.invokeMethod<bool>('isStreamAlive') ?? false;
    }).whenComplete(() => _isStreamAlive = false);

    return playFuture;
  }

  Future<dynamic> stop() async {
    return await _channel.invokeMethod('stop');
  }

  bool get isStreamAlive => _isStreamAlive;
}

typedef RtspFFMpegCreatedCallback = void Function(RtspController controller);

class RtspFFMpeg extends StatefulWidget {
  final RtspFFMpegCreatedCallback createdCallback;

  const RtspFFMpeg({super.key, required this.createdCallback});

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
    log('id ${id}');
    widget.createdCallback(rtspController);
  }
}

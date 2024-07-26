import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final rtspController = RtspController(0);

final class RtspController {
  static const watchdogPeriod = Duration(milliseconds: 100);
  static const nativeCallTimeout = Duration(milliseconds: 500);

  RtspController(int id) {
    _channel = MethodChannel('rtsp_ffmpeg$id');
  }

  late MethodChannel _channel;

  StreamController<bool> _streamAliveController = StreamController<bool>();

  Stream<bool> get streamAliveWatcher => _streamAliveController.stream;

  bool _isStreamAlive = false;
  bool _started = false;

  late Future<void> _watchdog = Future.value();

  Future<bool> play(String url) async {
    var success = true;
    _setStreamAlive(true);
    _started = false;
    final playFuture = _channel.invokeMethod('play', url);

    _watchdog.ignore();
    _watchdog = Future.doWhile(() async {
      if (!_started) {
        await Future.delayed(const Duration(seconds: 1));
        _started = true;
      } else {
        await Future.delayed(watchdogPeriod);
      }
      return await _channel.invokeMethod<bool>('isStreamAlive') ?? false;
    }).whenComplete(() => _setStreamAlive(false));

    await playFuture.timeout(nativeCallTimeout,
        onTimeout: () => success = false);

    return success;
  }

  Future<bool> stop() async {
    var success = true;
    await _channel
        .invokeMethod('stop')
        .timeout(nativeCallTimeout, onTimeout: () => success = false);
    return success;
  }

  void _setStreamAlive(bool newStatus) {
    if (_isStreamAlive == newStatus) {
      return;
    }

    _isStreamAlive = newStatus;
    _streamAliveController.add(_isStreamAlive);
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

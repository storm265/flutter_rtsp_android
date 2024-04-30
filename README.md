# rtsp_ffmpeg

An FFMPEG based RTSP player flutter plugin. This support Almost real time RTSP playback using native code.

## Getting Started


# flutter_useful_tools

Example
`
Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: RtspFFMpeg(
          createdCallback: (controller) async {
            await controller.play('rtsp://192.168.65.122:8554/test');
          },
        ),
      ),
`

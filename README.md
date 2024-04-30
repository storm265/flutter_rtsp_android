# rtsp_ffmpeg

An FFMPEG based RTSP player flutter plugin. This support Almost real time RTSP playback using native code.

## Getting Started


# flutter_useful_tools

Example
`RtspFFMpeg(

          createdCallback: (controller) async 
          {
            await controller.play('rtsp://xxx.xxx.xx.xxx:8554/test'); // Put your link to stream
          },
        ),
        `

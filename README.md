# rtsp_ffmpeg

An FFMPEG based RTSP player flutter plugin. This support Almost real time RTSP playback using native code.

## Getting Started


Example:


#### # Add to your project:
```dependencies:
  flutter:
    sdk: flutter


  rtsp_ffmpeg:
    git: 
      url: https://github.com/keodoff/flutter_rtsp_android.git
      ref: main
	 ```
      


```Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: RtspFFMpeg(
          createdCallback: (controller) async {
            await controller.play('rtsp://xxx.xxx.xx.xxx:8554/test'); //Put your rtsp
          },
        ),
      ),
	  ```
	  
	  

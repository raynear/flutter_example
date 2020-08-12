import 'package:camera/camera.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:hire/main.dart';

class Camera extends StatefulWidget {
  @override
  _Camera createState() => _Camera();
}

class _Camera extends State<Camera> {
  CameraController _controller;
  List<CameraDescription> cameras;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _findCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.high);
    await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
        actions: [
          CircleAvatar(
              radius: appBarHeight * 1.0,
              backgroundColor: Colors.teal[200],
              child: CircleAvatar(
                radius: appBarHeight * 0.9,
                // backgroundImage: CachedNetworkImageProvider(
                //   Provider.of<Account>(context).avatar,
                // ),
                backgroundColor: Colors.transparent,
              ))
        ],
      ),
      body: FutureBuilder<void>(
          future: _findCamera(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _controller.initialize();
            // path 패키지를 사용하여 이미지가 저장될 경로를 지정합니다.
            final path = join(
              // 본 예제에서는 임시 디렉토리에 이미지를 저장합니다. `path_provider`
              // 플러그인을 사용하여 임시 디렉토리를 찾으세요.
              (await getApplicationDocumentsDirectory()).path,
              '${DateTime.now()}.png',
            );

            print(path);

            // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
            await _controller.takePicture(path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

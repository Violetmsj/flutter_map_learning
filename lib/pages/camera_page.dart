import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_learning/get_controller/get_camera_controller.dart';
import 'package:flutter_map_learning/get_controller/loading_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;

class CameraPage extends StatefulWidget {
  // final CameraDescription camera;
  const CameraPage({
    super.key,
    // required this.camera
  });
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final getCameraController = Get.find<GetCameraController>();
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      getCameraController.getFirstCamera.value!,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('拍照页面', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({super.key, required this.imagePath});
  final isLoadingController = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Obx(() => ElevatedButton(
              onPressed: isLoadingController.isLoading.value
                  ? null
                  : () async {
                      var fileDir = imagePath;
                      dio_package.FormData formData =
                          dio_package.FormData.fromMap({
                        "upload":
                            await dio_package.MultipartFile.fromFile(fileDir)
                      });
                      isLoadingController.setIsLoading(true);
                      var response = await dio_package.Dio().post(
                          "https://apifoxmock.com/m2/5982064-5670419-default/270079311",
                          data: formData);
                      isLoadingController.setIsLoading(false);
                      print(response);
                      Get.snackbar("上传成功", "欢迎上传");
                    },
              child: isLoadingController.isLoading.value
                  ? Text("上传中")
                  : Text("上传")))
        ],
      ),
    );
  }
}

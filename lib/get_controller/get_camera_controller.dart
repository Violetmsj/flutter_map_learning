import 'package:camera/camera.dart';
import 'package:get/get.dart';

class GetCameraController extends GetxController {
  var getFirstCamera = Rx<CameraDescription?>(null);
  void setFirstCamera(CameraDescription camera) {
    // firstCamera.value = camera.value;
    getFirstCamera.value = camera;
  }
}

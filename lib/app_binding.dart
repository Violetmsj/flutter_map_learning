import 'package:flutter_map_learning/get_controller/get_camera_controller.dart';
import 'package:flutter_map_learning/get_controller/loading_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetCameraController());
    Get.lazyPut(() => LoadingController(), fenix: true);
  }
}

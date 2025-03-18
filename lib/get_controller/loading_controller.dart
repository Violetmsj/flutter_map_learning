import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;
  void setIsLoading(bool status) {
    isLoading.value = status;
  }
}

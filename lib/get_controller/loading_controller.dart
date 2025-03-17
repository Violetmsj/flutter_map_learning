import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;
  void setIsLoading(status) {
    isLoading.value = status;
  }
}

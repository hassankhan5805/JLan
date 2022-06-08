import 'package:get/get.dart';

class LoadingController extends GetxController {
  final Rx<bool> isLoading = false.obs;
  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }
}
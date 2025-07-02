import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/bottom_bar_controller.dart';
import '../controller/profile_controller.dart';

class BottomBarBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService());
    Get.put(BottomBarController());
    Get.lazyPut(() => ProfileController());
  }
}

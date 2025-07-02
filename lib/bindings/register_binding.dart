import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/register_controller.dart';
import '../repository/register_repo.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService());
    Get.put(RegisterRepo());
    Get.put(RegisterController());
  }
}

import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/logout_controller.dart';
import '../controller/profile_controller.dart';
import '../repository/logout_repo.dart';

class LogoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService(), permanent: true);
    Get.put(ProfileController());
    Get.put(LogoutRepository(), permanent: true);
    Get.put(LogoutController(), permanent: true);
  }
}

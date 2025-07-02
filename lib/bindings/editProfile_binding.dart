import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/edit_profile_controller.dart';
import '../controller/profile_controller.dart';
import '../repository/edit_profile_repository.dart';

class EditProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService());
    Get.put(EditProfileRepository());
    Get.put(ProfileController());
    Get.put(EditProfileController());
  }
}

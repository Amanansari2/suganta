import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/privacy_policy_controller.dart';
import '../repository/privacy_policy_repo.dart';

class PrivacyPolicyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService());
    Get.put(PrivacyPolicyRepository());
    Get.lazyPut(() => PrivacyPolicyController());
  }
}

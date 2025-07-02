import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/login_controller.dart';
import '../repository/login_repo.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostService>(() => PostService(), fenix: true);
    Get.lazyPut<LoginRepository>(() => LoginRepository(), fenix: true);
    Get.put<LoginController>(LoginController(), permanent: true);
  }
}

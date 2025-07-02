import 'package:get/get.dart';

import '../api_service/putService.dart';
import '../controller/project_post_edit_project_controller.dart';
import '../repository/project_post_edit_project_repo.dart';

class PostProjectEditProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PutService());
    Get.lazyPut(() => ProjectPostEditProjectRepo());
    Get.lazyPut(() => ProjectPostEditProjectController());
  }
}

import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/contact_developer_controller.dart';
import '../repository/contact_developer_repo.dart';

class ContactDeveloperBindings extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final int? projectId = args['projectId'] as int?;

    if (projectId == null) {
      throw Exception('projectId is null in ContactDeveloperBindings');
    }

    Get.put(PostService());
    Get.put(ContactDeveloperRepository());
    Get.put(ContactDeveloperController(projectId));
  }
}

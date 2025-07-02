import 'package:get/get.dart';

import '../api_service/putService.dart';
import '../controller/residential_post_edit_property_controller.dart';
import '../repository/residental_post_edit_property_repo.dart';

class PostResidentialEditPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PutService());
    Get.lazyPut(() => ResidentialPostEditPropertyRepository());
    Get.lazyPut(() => ResidentialPostEditPropertyController());
  }
}

import 'package:get/get.dart';

import '../api_service/putService.dart';
import '../controller/commercial_post_edit_property_controller.dart';
import '../repository/commercial_post_edit_property_repo.dart';

class PostCommercialEditPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PutService());
    Get.lazyPut(() => CommercialPostEditPropertyRepository());
    Get.lazyPut(() => CommercialPostEditPropertyController());
  }
}

import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/commercial_post_property_controller.dart';
import '../controller/pg_post_property_controller.dart';
import '../controller/project_post_property_controller.dart';
import '../controller/residential_post_property_controller.dart';
import '../repository/commercial_post_property_repo.dart';
import '../repository/pg_post_property_repo.dart';
import '../repository/project_post_property_repo.dart';
import '../repository/residential_post_property_repo.dart';

class PostPropertyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService(), permanent: true);
    Get.put(ResidentialPostPropertyRepo());
    Get.lazyPut(() => ResidentialPostPropertyController(), fenix: false);
    Get.put(CommercialPostPropertyRepo());
    Get.lazyPut(() => CommercialPostPropertyController(), fenix: false);
    Get.put(PGPostPropertyRepository());
    Get.lazyPut(() => PGPostPropertyController(), fenix: false);
    Get.put(ProjectPostPropertyRepo());
    Get.lazyPut(() => ProjectPostPropertyController(), fenix: false);
  }
}

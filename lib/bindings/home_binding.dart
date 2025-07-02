import 'package:get/get.dart';

import '../api_service/putService.dart';
import '../controller/home_controller.dart';
import '../controller/pg_post_edit_property_controller.dart';
import '../repository/home_your_listing_repository.dart';
import '../repository/pg_post_edit_property_repo.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PutService());
    Get.lazyPut(() => HomeYourListingRepository());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PGPostEditPropertyRepository());
    Get.lazyPut(() => PGPostEditPropertyController());
  }
}

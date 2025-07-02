import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/search_filter_controller.dart';
import '../repository/search_property_repo.dart';

class SearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostService());
    Get.put(SearchPropertyRepository());
    Get.put(SearchFilterController());
  }
}

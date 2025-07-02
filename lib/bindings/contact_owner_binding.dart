import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/contact_owner_controller.dart';
import '../repository/contact_owner_repo.dart';

class ContactOwnerBindings extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final int propertyId = args['propertyId'];

    Get.put(PostService());
    Get.put(ContactOwnerRepository());
    Get.put(ContactOwnerController(propertyId));
  }
}

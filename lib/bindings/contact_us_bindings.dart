import 'package:get/get.dart';

import '../api_service/putService.dart';
import '../controller/contactUs_controller.dart';
import '../repository/contact_us_repo.dart';

class ContactUsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PutService());
    Get.put(ContactUsRepository());
    Get.put(ContactUsController());
  }
}

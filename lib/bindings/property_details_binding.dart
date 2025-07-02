
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/property_details_controller.dart';

class PropertyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // final args = Get.arguments;
    // final property = args['property'];
    // final controller = PropertyDetailsController();
    // controller.setProperty(property);
    // Get.put(controller);

    Get.lazyPut(()=>PropertyDetailsController());
  }
}



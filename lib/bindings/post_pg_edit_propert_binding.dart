import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../api_service/putService.dart';
import '../controller/pg_post_edit_property_controller.dart';
import '../repository/pg_post_edit_property_repo.dart';

class PostPgEditPropertyBinding extends Bindings{

  @override
  void dependencies() {
    Get.put(PutService());
    Get.lazyPut(()=>PGPostEditPropertyRepository());
    Get.lazyPut(()=> PGPostEditPropertyController());
  }
}
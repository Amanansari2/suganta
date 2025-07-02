import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../controller/update_credentials_controller.dart';
import '../repository/update _credentials_repo.dart';

class UpdateCredentialsBindings extends Bindings{

  @override
  void dependencies(){
    Get.put(PostService());
    Get.put(UpdateCredentialRepository());
    Get.put(UpdateCredentialsController());

  }
}
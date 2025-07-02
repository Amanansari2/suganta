import 'package:get/get.dart';

import '../api_service/putService.dart';
import '../controller/term_condition_controller.dart';
import '../repository/term_condition_repo.dart';

class TermConditionBindings extends Bindings{

  @override
  void dependencies() {
    Get.put(PutService());
    Get.put(TermConditionRepository());
    Get.lazyPut(()=>TermConditionController(), fenix: true);
  }
}
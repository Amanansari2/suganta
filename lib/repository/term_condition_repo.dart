import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class TermConditionRepository {
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> termCondition() async {
    final response = await GetService.getRequest(
        url: getTermConditionUrl, requiresAuth: false);

    AppLogger.log("Term And Condition  data Received -->> ${response["data"]}");

    if (response["success"] == true) {
      final innerData = response["data"]?["data"];
      AppLogger.log("Inner data -->> $innerData");

      return {"success": true, "data": innerData};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

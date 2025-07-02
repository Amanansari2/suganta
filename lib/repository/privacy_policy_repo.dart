import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class PrivacyPolicyRepository{
  final GetService getService = Get.find<GetService>();
  Future<Map<String, dynamic>> privacyPolicy() async {
    final response = await GetService.getRequest(
        url: getPrivacyPolicyUrl,
    requiresAuth:  false
    );

    AppLogger.log("Privacy and Policy  data Received -->> ${response["data"]}");
    if(response["success"]==true){
      final innerData = response["data"]?["data"];
      AppLogger.log("PrivacyPolicy InnerData-->>> $innerData");

      return {
        "success": true,
        "data": innerData
      };
    } else {
      return {
        "success": false,
        "message": response["message"]
      };
    }
  }
}
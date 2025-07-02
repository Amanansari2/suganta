import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class PGPropertyRepository {
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> pgCountPropertyList() async {
    final response = await GetService.getRequest(
        url: getPGPropertyCountUrl, requiresAuth: false);

    if (response["success"] == true) {
      AppLogger.log("PG Property Count data Received -->> ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> pgFeaturePropertyList({int page = 1}) async {
    final pgFeatureFullUrl = "$getPGPropertyFeatureUrl?page=$page";
    final response =
        await GetService.getRequest(url: pgFeatureFullUrl, requiresAuth: false);

    if (response["success"] == true) {
      AppLogger.log("Pg Feature Property Data Received ${response["data"]}");

      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> pgTopRatedPropertyList({int page = 1}) async {
    final pgTopRatedFullUrl = "$getPGPropertyTopRatedUrl?page=$page";
    final response = await GetService.getRequest(
        url: pgTopRatedFullUrl, requiresAuth: false);

    if (response["success"] == true) {
      AppLogger.log(
          "Pg Top Rated Property Data Received -->>>> ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

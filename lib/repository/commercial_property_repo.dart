import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class CommercialPropertyRepository {
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> commercialShopShowRoomPropertyList(
      {int page = 1}) async {
    final commercialShopShowRoomFullUrl =
        "$getCommercialPropertyShopShowRoomUrl?page=$page";

    final response = await GetService.getRequest(
        url: commercialShopShowRoomFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log(
          "Commercial OneStop Count Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> commercialOwnerPropertyList(
      {int page = 1}) async {
    final commercialOwnerFullUrl = "$getCommercialPropertyOwnerUrl?page=$page";

    final response = await GetService.getRequest(
        url: commercialOwnerFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log(
          "Commercial Shop ShowRoom Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> commercialOfficeSpacePropertyList(
      {int page = 1}) async {
    final commercialOfficeFullUrl =
        "$getCommercialPropertyOfficeSpaceUrl?page=$page";

    final response = await GetService.getRequest(
        url: commercialOfficeFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log(
          "Commercial Posted by Owner Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> commercialOneStopCountPropertyList() async {
    final response = await GetService.getRequest(
        url: getCommercialPropertyOneStopCountUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log(
          "Commercial Office Space Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

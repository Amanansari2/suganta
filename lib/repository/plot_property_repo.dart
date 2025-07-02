import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class PlotPropertyRepository {
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> plotFeaturePropertyList({int page = 1}) async {
    final plotFeatureFullUrl = "$getPlotPropertyFeatureUrl?page=$page";

    final response = await GetService.getRequest(
        url: plotFeatureFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log(
          "Plot Investment Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> plotInvestmentPropertyList(
      {int page = 1}) async {
    final plotInvestmentFullUrl = "$getPlotPropertyInvestmentUrl?page=$page";
    final response = await GetService.getRequest(
        url: plotInvestmentFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log(
          "Plot Feature Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> plotOwnerPropertyList({int page = 1}) async {
    final plotOwnerFullUrl = "$getPlotPropertyOwnerUrl?page=$page";

    final response =
        await GetService.getRequest(url: plotOwnerFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      AppLogger.log("Plot Owner Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

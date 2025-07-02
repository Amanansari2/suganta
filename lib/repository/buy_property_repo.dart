import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class BuyPropertyRepository {
  Future<Map<String, dynamic>> buyFeaturePropertyList({int page = 1}) async {
    final buyFeatureFullUrl = "$getBuyPropertyFeatureUrl?page=$page";
    AppLogger.log("Calling Feature Properties API...");
    final response = await GetService.getRequest(
        url: buyFeatureFullUrl, requiresAuth: false);

    // AppLogger.log("Feature Properties API Response: $response");

    if (response["success"] == true) {
      // AppLogger.log("Feature Properties Data Received: ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> buyOwnerPropertyList({int page = 1}) async {
    final buyOwnerFullUrl = "$getBuyPropertyOwnerUrl?page=$page";

    final response =
        await GetService.getRequest(url: buyOwnerFullUrl, requiresAuth: false);
    // print("Owner Properties API Response: $response");
    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> buyPremiumPropertyList({int page = 1}) async {
    final buyPremiumFullUrl = "$getBuyPropertyPremiumUrl?page=$page";
    final response = await GetService.getRequest(
        url: buyPremiumFullUrl, requiresAuth: false);

    //  print("Premium Properties API Response: $response");

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> buyDelhiPropertyList({int page = 1}) async {
    final buyDelhiFullUrl = "$getBuyPropertyDelhiUrl?page=$page";
    final response =
        await GetService.getRequest(url: buyDelhiFullUrl, requiresAuth: false);

    //  print("Delhi Properties Api Response -->>> $response");

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

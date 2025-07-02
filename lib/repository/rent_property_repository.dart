import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class RentPropertyRepository {
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> rentTopPropertyList({int page = 1}) async {
    final fullUrlTopProperty = "$getRentPropertyTopUrl?page=$page";
    Get.log("Making Request to rent top property -->>> $fullUrlTopProperty");
    final response = await GetService.getRequest(
        url: fullUrlTopProperty, requiresAuth: false);

    AppLogger.log("API Response Rent Properties: $response");

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> rentOwnerPropertyList({int page = 1}) async {
    final fullUrl = "$getRentPropertyOwnerUrl?page=$page";
    AppLogger.log("➡️ Making request to: $fullUrl");

    final response =
        await GetService.getRequest(url: fullUrl, requiresAuth: false);
    AppLogger.log("Rent Owner Property Raw Response: $response");

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

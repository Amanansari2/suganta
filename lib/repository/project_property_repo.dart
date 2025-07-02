import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class ProjectPropertyRepository {
  Future<Map<String, dynamic>> projectFeaturePropertyList(
      {int page = 1}) async {
    final projectFeatureFullUrl = "$getProjectPropertyFeatureUrl?page=$page";
    AppLogger.log("Calling Feature Projects .... ");
    final response = await GetService.getRequest(
        url: projectFeatureFullUrl, requiresAuth: false);
    if (response["success"] == true) {
      // AppLogger.log("Feature Project Data -->>> $response");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> projectDreamPropertyList({int page = 1}) async {
    final projectDreamFullUrl = "$getProjectPropertyDreamUrl?page=$page";
    final response = await GetService.getRequest(
        url: projectDreamFullUrl, requiresAuth: false);

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

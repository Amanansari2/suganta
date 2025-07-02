import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class SearchPropertyRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> getSearchList({
    int page = 1,
    required Map<String, dynamic> payload,
  }) async {
    final searchUrl = "$getSearchResultUrl?page=$page";
    final response = await postService.postRequest(
        url: searchUrl, requiresAuth: false, body: payload);

    AppLogger.log("Raw search result Response ->>$response");

    if (response["success"] == true) {
      AppLogger.log("Search Data -->> ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> getProjectSearchList({
    int page = 1,
    required Map<String, dynamic> payload,
  }) async {
    final projectSearchUrl = "$getProjectSearchResultUrl?page=$page";
    final response = await postService.postRequest(
        url: projectSearchUrl, body: payload, requiresAuth: false);

    AppLogger.log("Raw Project Search result response -->> $response");
    if (response["success"] == true) {
      AppLogger.log("Project Search Data -->> ${response["data"]}");
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> fetchSearchDropDownList() async {
    final response = await GetService.getRequest(
        url: getProjectDropDownUrl, requiresAuth: false);
    AppLogger.log("raw DropDownList -->>> $response");
    if (response["success"] == true) {
      return {"success": true, "data": response["data"]?["data"]};
    } else {
      return {"success": false, "message": response["data"]?["message"]};
    }
  }
}

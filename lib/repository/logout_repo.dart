import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class LogoutRepository {
  final PostService postService = Get.find<PostService>();
  final GetStorage storage = GetStorage();

  Future<Map<String, dynamic>> logoutUser({bool allDevices = false}) async {
    String? token = storage.read("auth_token");

    AppLogger.log("logging out Token---->>> $token");

    if (token == null) {
      AppLogger.log("No token found, returning error.");
      return {
        "success": false,
        "message": "No token found. User not logged in"
      };
    }

    Map<String, dynamic> requestBody = {"all_devices": allDevices};
    AppLogger.log("Sending logout request...");

    final response = await postService.postRequest(
        url: logoutUrl, body: requestBody, requiresAuth: true);
    AppLogger.log("Logout API Response: $response");
    if (response["success"] == true ||
        response["message"] == "Logged out successfully") {
      return {"success": true, "message": "Logged out successfully"};
    } else {
      AppLogger.log("Logout failed. Response message: ${response["message"]}");
      return {
        "success": true,
        "message": response["message"] ?? "Logout failed"
      };
    }
  }
}

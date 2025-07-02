import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/login_model.dart';

class LoginRepository {
  final PostService postService = Get.find<PostService>();
  final storage = GetStorage();

  Future<Map<String, dynamic>> loginUser({
    required String login,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      "login": login,
      "password": password,
    };
    final response = await postService.postRequest(
      url: loginUrl,
      body: body,
      requiresAuth: false,
    );
    AppLogger.log(" Raw API Response: ${response.toString()}");
    String message =
        response.containsKey("message") && response["message"] != null
            ? response["message"].toString()
            : response.containsKey("data") &&
                    response["data"].containsKey("message")
                ? response["data"]["message"].toString()
                : "Login successful!";
    if (response["success"] == true) {
      AppLogger.log("success message --->> $message");
      return {
        "success": true,
        "message": message,
        "user": LoginModel.fromJson(response["data"]),
      };
    } else {
      String errorMessage = (response["error"]?["email"] is List &&
              response["error"]["email"].isNotEmpty)
          ? response["error"]["email"][0]
          : response["message"] ?? "Something went wrong";

      AppLogger.log("error message from repository -->>> $errorMessage");

      return {
        "success": false,
        "message": errorMessage,
        "error": response["error"]
      };
    }
  }

  Future<Map<String, dynamic>> forgetPassword({required String email}) async {
    AppLogger.log("📧 Received email: $email");

    Map<String, dynamic> body = {"email": email};

    AppLogger.log("📦 Request Body: $body");

    try {
      final response = await postService.postRequest(
          url: forgotPasswordUrl, body: body, requiresAuth: false);
      AppLogger.log(" Raw API Response: $response");

      if (response["success"] == true) {
        String successMsg =
            response["data"]?["message"]?.toString() ?? "Success";
        AppLogger.log("✅ Success Message: $successMsg");
        return {
          "success": true,
          "message": successMsg,
        };
      } else {
        String errorMsg = response["errors"]?["error"]?["email"]?[0] ??
            response["message"]?.toString() ??
            "Something went wrong";

        AppLogger.log("🛑 Error Message: $errorMsg");
        return {"success": false, "message": errorMsg};
      }
    } catch (e, stackTrace) {
      AppLogger.log("🔥 Exception Occurred: $e");
      AppLogger.log("🧵 Stack Trace: $stackTrace");

      return {
        "success": false,
        "message": "Failed to connect to server. Please try again.",
      };
    }
  }
}

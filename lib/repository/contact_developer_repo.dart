import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class ContactDeveloperRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> contactDeveloper({
    required String name,
    required String phone,
    required String email,
    required int projectId,
    String? token
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "mobile": phone,
      "project_id": projectId
    };
    if (token != null && token.isNotEmpty) {
      body["token"] = token;
    }


    AppLogger.log("➡ Request Body Before POST: $body");


    final response = await postService.postRequest(
        url: contactDeveloperLeadGenerateUrl,
        body: body,
        requiresAuth: token != null && token.isNotEmpty,);
    AppLogger.log("➡First step Full API response: $response");
    String message =
        response.containsKey("message") && response["message"] != null
            ? response["message"].toString()
            : response.containsKey("data") &&
                    response["data"].containsKey("message")
                ? response["data"]["message"].toString()
                : "otp sent";

    AppLogger.log("Lead generate Otp Sent message -->> $message");
    if (response["success"] == true && response.containsKey("data")) {
      final leadStatus = response["data"]?["lead_status"] ?? 0;
      Get.log("Lead generate Otp Sent message -->> $leadStatus");
      return {
        "success": true,
        "message": message,
        "lead_status": leadStatus,
      };
    } else {
      return {
        "success": false,
        "message": response["message"],
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String name,
    required String phone,
    required String email,
    required int projectId,
    required int otp,
  }) async {
    String extractErrorMessage(Map<String, dynamic> response) {
      return response["error"]?["message"]?.toString() ??
          response["data"]?["message"]?.toString() ??
          response["message"]?.toString() ??
          "Something went wrong";
    }

    Map<String, dynamic> body = {
      "name": name,
      "otp": otp,
      "email": email,
      "mobile": phone,
      "project_id": projectId
    };
    final response = await postService.postRequest(
      url: contactDeveloperLeadGenerateUrl,
      body: body,
      requiresAuth: false,
    );
    AppLogger.log("➡ Full API response: $response");

    String message = response["message"] ??
        (response["data"] != null && response["data"]["message"] != null
            ? response["data"]["message"].toString()
            : "Something went wrong");

    String errorMessage = extractErrorMessage(response);
    if (response["success"] == true && response.containsKey("data")) {
      try {
        int leadStatus = response["data"]?["lead_status"] ?? 0;
        Get.log("Verify otp lead status -->>> $leadStatus");
        return {
          "success": true,
          "message": message,
          "lead_status": leadStatus,
        };
      } catch (e) {
        return {
          "success": false,
          "message": "Failed to parse user data",
        };
      }
    } else {
      AppLogger.log("➡ Response success key: ${response["success"]}");
      AppLogger.log("➡ Response message: $errorMessage");
      int leadStatus = response["lead_status"] ?? 0;
      Get.log("Error otp lead status -->>> $leadStatus");
      return {
        "success": false,
        "message": errorMessage,
        "lead_status": leadStatus,
      };
    }
  }
}

import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class ContactOwnerRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> contactOwner({
    required String name,
    required String phone,
    required String email,
    required int propertyId,
    String? token
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "mobile": phone,
      "property_id": propertyId
    };
    if (token != null && token.isNotEmpty) {
      body["token"] = token;
    }


    AppLogger.log("➡ Request Body Before POST: $body");

    final response = await postService.postRequest(
        url: contactOwnerLeadGenerateUrl, body: body, requiresAuth: false);
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
    required int propertyId,
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
      "property_id": propertyId
    };
    final response = await postService.postRequest(
      url: contactOwnerLeadGenerateUrl,
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

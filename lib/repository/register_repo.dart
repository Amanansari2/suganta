import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/register_model.dart';

class RegisterRepo{

  final PostService postService = Get.find<PostService>();
  Future<Map<String,dynamic>> registerUser({
    required int role,
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
}) async {
    Map<String, dynamic> body = {
      "role":role,
      "name":name,
      "phone":phone,
      "email":email,
      "password":password,
      "password_confirmation":passwordConfirmation
    };

    final response = await postService.postRequest(
        url: signUpUrl,
        body: body,
        requiresAuth: false
    );



    String message = response.containsKey("message") && response["message"] != null
        ? response["message"].toString()
        : response.containsKey("data") && response["data"].containsKey("message")
        ? response["data"]["message"].toString()
        : "Registration successful!";

    AppLogger.log("Registration raw response  $response");
    if(response["success"] == true && response.containsKey("data")){
      return{
        "success":true,
        "message": message,
        "user": RegisterModel.fromJson(response["data"]),
      };
    } else{
      return{
        "success":false,
        "message":response["message"],
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtpAndRegister({
    required int role,
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String otp,
  }) async {
    Map<String, dynamic> body = {
      "role": role,
      "otp": otp,
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
    AppLogger.log("========== [DEBUG] OTP REGISTER FLOW ==========");
    AppLogger.log("Step 1: Request Body => $body");
    AppLogger.log("Step 2: Sending POST request to => $signUpUrl");

    final response = await postService.postRequest(
      url: signUpUrl,
      body: body,
      requiresAuth: false,
    );
    AppLogger.log("Step 3: Raw API Response => $response");

    String message = response["message"] ??
        (response["data"] != null && response["data"]["message"] != null
            ? response["data"]["message"].toString()
            : "Something went wrong");

    String errorMessage = response["error"]?["message"] ??
        response["message"] ??
        (response["data"] != null && response["data"]["message"] != null
            ? response["data"]["message"].toString()
            : "Something went wrong");


    AppLogger.log("Step 4: Extracted message => $message");

    if (response["success"] == true && response.containsKey("data")) {
      AppLogger.log("Step 5: Success TRUE. Converting to RegisterModel...");
      try {
        final userData = RegisterModel.fromJson(response["data"]);
        AppLogger.log("Step 6: Converted RegisterModel => $userData");

        return {
          "success": true,
          "message": message,
          "user": RegisterModel.fromJson(response["data"]),
        };
      } catch (e) {
        AppLogger.log("❌ Step 6: Failed to convert RegisterModel. Error: $e");
        return {
          "success": false,
          "message": "Failed to parse user data",
        };
      }
    } else {
      AppLogger.log("❌ Step 5: Registration FAILED.");
      AppLogger.log("➡ Response success key: ${response["success"]}");
      AppLogger.log("➡ Response message: $errorMessage");
      return {
        "success": false,
        "message": errorMessage,
      };
    }
  }



}
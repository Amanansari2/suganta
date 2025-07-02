import 'dart:io';

import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class EditProfileRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String alternateNumber,
    required String gender,
    required String dealsOn,
    required String officeName,
    required String aboutUs,
    required String country,
    required int state,
    required int city,
    required String area,
    required String pinCode,
    // required String address,
    String? imagePath,
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "alternate_mno": alternateNumber,
      "gender": gender,
      "dealsOn": dealsOn,
      "office_name": officeName,
      "about_us": aboutUs,
      "country": country,
      "state": state,
      "city": city,
      "area": area,
      "pincode": pinCode
      // "address": address,
    };

    if (imagePath != null) {
      final file = File(imagePath);
      final fileName = file.path.split('/').last;
      final fileSize = await file.length();

      AppLogger.log("📂 Image Name: $fileName");
      AppLogger.log("📏 Image Size: $fileSize bytes");
    }

    final response = await postService.postImageRequest(
      url: updateProfileUrl,
      body: body,
      filePath: imagePath,
      requiresAuth: true,
    );

    AppLogger.log(" Raw API Response: ${response.toString()}");
    AppLogger.log(" Response Success: ${response["success"]}");
    AppLogger.log(" Response Message: ${response["message"]}");
    AppLogger.log(" Response Data: ${response["data"]}");

    if (response["success"] == true) {
      return {
        "success": true,
        "message": response["message"] ?? "Profile updated successfully!",
      };
    } else {
      return {
        "success": false,
        "message": response["message"] ?? "Failed to update profile.",
      };
    }
  }
}

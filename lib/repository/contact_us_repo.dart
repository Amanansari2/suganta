import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class ContactUsRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> contactUs({
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "mobile": phone,
      "message": message
    };
    final response = await postService.postRequest(
        url: contactUsUrl, body: body, requiresAuth: false);
    AppLogger.log("Contact us Response -->>> $response");

    if (response["success"] == true) {
      return {"success": true, "message": response["data"]?["message"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

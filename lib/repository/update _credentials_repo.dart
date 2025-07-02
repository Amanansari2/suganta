import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/url.dart';

class UpdateCredentialRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> updateCredentials(
      Map<String, dynamic> body) async {
    final response = await postService.postRequest(
        url: updateCredentialsUrl, body: body, requiresAuth: true);

    if (response["success"] == true) {
      return {
        "success": true,
        "message": response["message"] ?? "Update Successfully"
      };
    } else {
      return {
        "success": false,
        "message": response["message"] ?? "failed to update"
      };
    }
  }
}

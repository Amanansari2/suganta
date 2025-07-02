import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/api_service/post_service.dart';
import 'package:tytil_realty/api_service/print_logger.dart';
import 'package:tytil_realty/api_service/url.dart';


class AuthorizationChecker {
  static final GetStorage _storage = GetStorage();

  static final PostService _postService = PostService();

  static Future<bool> validateTokenOnStartup(String token) async {
    try {
      final response = await _postService.postRequest(
        url: initialCheckUrl,
        body: {"testToken": token},
        requiresAuth: true,
      );


      final statusCode = response["statusCode"];
      AppLogger.log("Authorization response status: $statusCode");
      AppLogger.log("Authorization response body: ${response["data"]}");

      return response["success"] == true;
    } catch (e) {
      AppLogger.log("Authorization check failed: $e");
      return false;
    }
  }

}

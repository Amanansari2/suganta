import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';

class WishlistRepository {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> toggleWishlist(int propertyId) async {
    final response = await postService.postRequest(
        url: wishlistUrl,
        body: {"property_id": propertyId},
        requiresAuth: true);

    AppLogger.log("Wishlist  Toggle Response -->>> $response");

    if (response["success"] == true) {
      final rawStatus = response["data"]?["status"];
      final int status = rawStatus is int
          ? rawStatus
          : int.tryParse(rawStatus.toString()) ?? 0;

      AppLogger.log("Wishlist Status -->> $status");

      return {
        "success": true,
        "wishlisted": status == 1,
        "message": response["data"]?["message"]
      };
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> fetchProjectWishList() async {
    final response = await GetService.getRequest(
        url: getProjectWishlistStatusUrl, requiresAuth: true);
    print("GET Token: ${GetStorage().read("auth_token")}");

    AppLogger.log("Project Wishlist Raw fetch response -->> $response ");

    if (response["success"] == true && response["data"]["data"] is List) {
      final List<int> projectIds = (response["data"]["data"] as List)
          .map((item) => int.tryParse(item["project_id"].toString()) ?? 0)
          .where((id) => id > 0)
          .toList();

      AppLogger.log("Fetched repository Wishlist IDs: $projectIds");

      return {
        "success": true,
        "data": {
          "ids": projectIds,
          "message":
              response["data"]["message"] ?? "Fetched wishlist successfully",
        }
      };
    } else {
      return {
        "success": false,
        "message": response["message"] ?? "Failed to fetch wishlist"
      };
    }
  }

  Future<Map<String, dynamic>> fetchWishListPropertyData({int page = 1}) async {
    final wishlistPropertyDataFullUrl =
        "$getWishlistPropertyDataUrl?page=$page";

    final response = await GetService.getRequest(
        url: wishlistPropertyDataFullUrl, requiresAuth: true);

    AppLogger.log("raw response for wishlist -->>> $response");
    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> toggleProjectWishList(int projectId) async {
    final response = await postService.postRequest(
        url: projectWishlistUrl,
        body: {"project_id": projectId},
        requiresAuth: true);

    AppLogger.log("Project Wishlist Toggle response -->> $response");
    if (response["success"] == true) {
      final projectRawStatus = response["data"]?["status"];
      final int projectStatus = projectRawStatus is int
          ? projectRawStatus
          : int.tryParse(projectRawStatus.toString()) ?? 0;

      return {
        "success": true,
        "wishlisted": projectStatus == 1,
        "message": response["data"]?["message"]
      };
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> fetchWishList() async {
    final response = await GetService.getRequest(
        url: getWishlistStatusUrl, requiresAuth: true);

    AppLogger.log("Wishlist Raw Fetch Response -->>> $response");

    if (response["success"] == true && response["data"]["data"] is List) {
      final List<int> ids = (response["data"]["data"] as List)
          .map((item) => int.tryParse(item["property_id"].toString()) ?? 0)
          .where((id) => id > 0)
          .toList();
      AppLogger.log("Fetched repository Wishlist IDs: $ids");
      return {
        "success": true,
        "data": {
          "ids": ids,
          "message":
              response["data"]["message"] ?? "Fetched wishlist successfully",
        }
      };
    } else {
      return {
        "success": false,
        "message": response["message"] ?? "Failed to fetch wishlist"
      };
    }
  }

  Future<Map<String, dynamic>> fetchWishListProjectData({int page = 1}) async {
    final projectWishlistPropertyDataFullUrl =
        "$getProjectWishlistPropertyDataUrl?page=$page";

    final response = await GetService.getRequest(
        url: projectWishlistPropertyDataFullUrl, requiresAuth: true);

    AppLogger.log("Project WishList raw response for wishlist -->>> $response");
    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

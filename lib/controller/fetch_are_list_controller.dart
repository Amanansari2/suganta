import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/area_model.dart';

class AreaList extends GetxController {
  final PostService postService = Get.find<PostService>();
  List<Area> areaList = [];

  Future<Map<String, dynamic>> fetchAreaList({required String cityName}) async {
    final response = await postService.postRequest(
        url: getAreaListUrl, body: {"city": cityName}, requiresAuth: false);

    if (response["success"] == true && response["data"] != null) {
      if (response["data"].containsKey("data") &&
          response["data"]["data"] != null) {
        return {"success": true, "data": response["data"]["data"]};
      } else {
        AppLogger.log("Area key not found in api response ");
        return {"success": false, "message": "Area list not available"};
      }
    } else {
      AppLogger.log("❌ API Error: ${response["message"] ?? "Unknown error"}");
      return {
        "success": false,
        "message": response["message"] ?? "Unable to fetch area list",
      };
    }
  }

  Future<void> loadArea(String cityName) async {
    try {
      final response = await fetchAreaList(cityName: cityName);

      if (response["success"] == true && response["data"] != null) {
        List<dynamic> data = response["data"];
        areaList = data.map((e) => Area.fromJson(e)).toList();
        Get.log(
            "✅ Area List loaded for $cityName with ${areaList.length} areas");
      } else {
        Get.log("Failed to Load Area ${response["message"]}");
      }
    } catch (e) {
      Get.log("Area List error  -->> $e");
    }
  }
}

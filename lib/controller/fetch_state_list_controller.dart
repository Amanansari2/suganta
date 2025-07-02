import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/state_model.dart';

class StateList extends GetxController {
  List<AppState> stateList = [];

  Future<Map<String, dynamic>> fetchStateList() async {
    final response =
        await GetService.getRequest(url: getStateListUrl, requiresAuth: false);
    if (response["success"] == true && response["data"] != null) {
      if (response["data"].containsKey("data") &&
          response["data"]["data"] != null) {
        return {"success": true, "data": response["data"]["data"]};
      } else {
        AppLogger.log("⚠️ Warning: 'Area' key not found in API response.");
        return {
          "success": false,
          "message": "Area data not available.",
        };
      }
    } else {
      AppLogger.log("❌ API Error: ${response["message"] ?? "Unknown error"}");
      return {
        "success": false,
        "message": response["message"] ?? "Unable to fetch city list",
      };
    }
  }

  Future<void> loadState() async {
    if (stateList.isNotEmpty) return;
    try {
      final response = await fetchStateList();
      if (response["success"] == true && response["data"] != null) {
        List<dynamic> data = response["data"];
        stateList = data.map((e) => AppState.fromJson(e)).toList();
        AppLogger.log("State List loaded once with ${stateList.length} State");
      } else {
        AppLogger.log("Failed to Load Area ${response["message"]}");
      }
    } catch (e) {
      AppLogger.log("StateList error  -->> $e");
    }
  }
}

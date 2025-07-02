import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/url.dart';

class ResidentialPropertyRepository {
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> residentialTopPremiumPropertyList(
      {int page = 1}) async {
    final residentialTopPremiumFullUrl =
        "$getResidentialPropertyTopPremiumUrl?page=$page";

    final response = await GetService.getRequest(
        url: residentialTopPremiumFullUrl, requiresAuth: false);

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }

  Future<Map<String, dynamic>> residentialOwnerPropertyList(
      {int page = 1}) async {
    final residentialOwnerFullUrl =
        "$getResidentialPropertyOwnerUrl?page=$page";

    final response = await GetService.getRequest(
        url: residentialOwnerFullUrl, requiresAuth: false);

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]};
    } else {
      return {"success": false, "message": response["message"]};
    }
  }
}

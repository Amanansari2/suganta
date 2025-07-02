import 'dart:io';

import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/putService.dart';
import '../api_service/url.dart';

class PGPostEditPropertyRepository {
  final PutService putService = Get.find<PutService>();
  final GetService getService = Get.find<GetService>();
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> fetchEditCityList() async {
    final response = await GetService.getRequest(
      url: getCityListUrl,
      requiresAuth: false,
    );

    if (response["success"] == true && response["data"] != null) {
      if (response["data"].containsKey("data") &&
          response["data"]["data"] != null) {
        return {
          "success": true,
          "data": response["data"]["data"],
        };
      } else {
        AppLogger.log("⚠️ Warning: 'city' key not found in API response.");
        return {
          "success": false,
          "message": "City data not available.",
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

  Future<Map<String, dynamic>> submitEditStep1PgDetails({
    required int propertyLogId,
    required int roomType,
    required String availabilityDate,
    required String suitableFor,
    required List<int> houseRules,
    required List<int> commonAmenities,
    required int totalFloors,
    required int propertyFloors,
    required String pgName,
  }) async {
    final String urlWithLogId = "$pgEditAddStep1Url/$propertyLogId";

    Map<String, dynamic> body = {
      "roomType": roomType,
      "availabilityDate": availabilityDate,
      "suitableFor": suitableFor,
      "houseRules": houseRules,
      "commonAmenities": commonAmenities,
      "totalFloors": totalFloors,
      "propertyFloors": propertyFloors,
      "pgName": pgName,
    };
    final response = await putService.putRequest(
      url: urlWithLogId,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitEditStep2PgDetails({
    required int propertyLogId,
    required String city,
    required String area,
    required String subLocality,
    required String houseNo,
    required String pin,
  }) async {
    final String urlWithLogId2 = "$pgEditAddStep2Url/$propertyLogId";

    Map<String, dynamic> body = {
      "city": city,
      "area": area,
      "sub_locality": subLocality,
      "house_no": houseNo,
      "pin": pin,
    };

    final response = await putService.putRequest(
      url: urlWithLogId2,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitEditStep3PgDetails({
    required int propertyLogId,
    required int rentAmount,
    required String uniquePropertyDescription,
    required int electricityExcluded,
    required int waterExcluded,
    required int isNegotiable,
  }) async {
    final String urlWithLogId3 = "$pgEditAddStep3Url/$propertyLogId";

    Map<String, dynamic> body = {
      "rentAmount": rentAmount,
      "uniquePropertyDescription": uniquePropertyDescription,
      "electricity_excluded": electricityExcluded,
      "water_excluded": waterExcluded,
      "is_negotiable": isNegotiable,
    };

    final response = await putService.putRequest(
      url: urlWithLogId3,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> uploadEditStep4Images({
    required int propertyImageId,
    required int propertyId,
    required List<File> imageFiles,
  }) async {
    if (imageFiles.isEmpty) {
      return {
        "success": false,
        "message": "No images selected.",
      };
    }
    final String urlWithLogId4 = "$propertyUploadImageUrl/$propertyImageId";

    final response = await postService.postMultipleImagesRequest(
      url: urlWithLogId4,
      imageFiles: imageFiles,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> deleteMultiplePropertyImages({
    required int propertyId,
    required List<int> imageIds,
  }) async {
    final body = {
      "property_id": propertyId,
      "img_id": imageIds.join(","),
    };

    // AppLogger.log("Image ids body -->> $body");
    //

    final response = await postService.postRequest(
        url: propertyDeleteImageUrl, body: body, requiresAuth: true);

    return response;
  }
}

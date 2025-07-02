import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/url.dart';
import '../configs/app_color.dart';

class PGPostPropertyRepository {
  final PostService postService = Get.find<PostService>();
  final GetService getService = Get.find<GetService>();

  Future<Map<String, dynamic>> submitStep1PgDetails({
    required int roomType,
    required String availabilityDate,
    required String suitableFor,
    required List<int> houseRules,
    required List<int> commonAmenities,
    required int totalFloors,
    required int propertyFloors,
    required String pgName,
  }) async {



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
    final response = await postService.postRequest(
      url: pgAddStep1Url,
      body: body,
      requiresAuth: true,
    );

    return response;
  }




  // Future<Map<String, dynamic>> fetchCityList() async {
  //   final response = await GetService.getRequest(
  //     url: getPGCityListUrl,
  //     requiresAuth: false,
  //   );
  //
  //   // print("🔍 API Full Response: $response");
  //
  //   if (response["success"] == true && response["data"] != null) {
  //     if (response["data"].containsKey("data") && response["data"]["data"] != null) {
  //       return {
  //         "success": true,
  //         "data": response["data"]["data"],
  //       };
  //     } else {
  //       print("⚠️ Warning: 'city' key not found in API response.");
  //       return {
  //         "success": false,
  //         "message": "City data not available.",
  //       };
  //     }
  //   } else {
  //     print("❌ API Error: ${response["message"] ?? "Unknown error"}");
  //     return {
  //       "success": false,
  //       "message": response["message"] ?? "Unable to fetch city list",
  //     };
  //   }
  // }



  Future<Map<String, dynamic>> submitStep2PgDetails({
  required String city,
  required String area,
  required String subLocality,
  required String houseNo,
  required String pin,
  }) async {

    final storage = GetStorage();
    int? pgId = storage.read("pg_id");
    if (pgId == null) {
      Get.snackbar("Error", "PG ID not found. Please complete Step 1 first.", backgroundColor: AppColor.red);
      return {"status": 400, "message": "PG ID not found"};
    }

    String urlWithPgId = "$pgAddStep2Url/$pgId";

  Map<String, dynamic> body = {
  "city": city,
  "area": area,
  "sub_locality": subLocality,
  "house_no": houseNo,
  "pin": pin,
  };

  final response = await postService.postRequest(
  url: urlWithPgId,
  body: body,
  requiresAuth: true,
  );

  return response;
  }

  Future<Map<String, dynamic>> submitStep3PgDetails({
    required int rentAmount,
    required String uniquePropertyDescription,
    required int electricityExcluded,
    required int waterExcluded,
    required int isNegotiable,
  }) async {
    final storage = GetStorage();
    int? pgId = storage.read("pg_id");

    if (pgId == null) {
      Get.snackbar("Error", "PG ID not found. Please complete Step 1 and Step 2 first.", backgroundColor: AppColor.red);
      return {"status": 400, "message": "PG ID not found"};
    }

    String urlWithPgId = "$pgAddStep3Url/$pgId";

    Map<String, dynamic> body = {
      "rentAmount": rentAmount,
      "uniquePropertyDescription": uniquePropertyDescription,
      "electricity_excluded": electricityExcluded,
      "water_excluded": waterExcluded,
      "is_negotiable": isNegotiable,
    };

    final response = await postService.postRequest(
      url: urlWithPgId,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> uploadStep4Images({
    required int propertyId,
    required List<File> imageFiles,
  }) async {
    if (imageFiles.isEmpty) {
      return {
        "success": false,
        "message": "No images selected.",
      };
    }

    final storage = GetStorage();
    int? propertyId = storage.read("property_id");

    if (propertyId == null) {
      Get.snackbar("Error", "PG Property ID not found. Please complete Step 3 first.", backgroundColor: AppColor.red);
      return {"status": 400, "message": "PG ID not found"};
    }

    String urlWithPropertyId = "$propertyUploadImageUrl/$propertyId";

    final response = await postService.postMultipleImagesRequest(
      url: urlWithPropertyId,
      imageFiles: imageFiles,
      requiresAuth: true,
    );

    return response;
  }





}


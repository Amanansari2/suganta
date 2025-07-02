import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../configs/app_color.dart';
import '../controller/residential_post_property_controller.dart';

class ResidentialPostPropertyRepo {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> submitStep1ResidentialDetails() async {
    final ResidentialPostPropertyController residentialPostPropertyController =
        Get.find<ResidentialPostPropertyController>();

    final Map<String, dynamic> body =
        residentialPostPropertyController.buildResidentialPayload();

    final response = await postService.postRequest(
        url: residentialAddStep1Url, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitStep2ResidentialDetails({
    required String city,
    required String area,
    required String subLocality,
    required String houseNo,
    required String pin,
  }) async {
    final storage = GetStorage();
    int? residentialId = storage.read("res_id");
    if (residentialId == null) {
      Get.snackbar(
          "Error", "Residential ID not found. Please complete Step 1 first.",
          backgroundColor: AppColor.red);
      return {"status": 400, "message": "Residential ID not found"};
    }

    String urlWithResidentialIdStep2 = "$residentialAddStep2Url/$residentialId";

    Map<String, dynamic> body = {
      "city": city,
      "area": area,
      "sub_locality": subLocality,
      "house_no": houseNo,
      "pin": pin,
    };

    final response = await postService.postRequest(
      url: urlWithResidentialIdStep2,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitStep3ResidentialDetails(
      {required int rentAmount,
      required String uniquePropertyDescription,
      required int allInclusivePrice,
      required int taxAndGovtChargesExcluded,
      required int priceNegotiable,
      required String ownerShip}) async {
    final storage = GetStorage();
    int? residentialId = storage.read("res_id");

    if (residentialId == null) {
      Get.snackbar(
          "Error", "PG ID not found. Please complete Step 1 and Step 2 first.",
          backgroundColor: AppColor.red);
      return {"status": 400, "message": "PG ID not found"};
    }

    String urlWithResidentialIdStep3 = "$residentialAddStep3Url/$residentialId";

    Map<String, dynamic> body = {
      "rent_amount": rentAmount,
      "description": uniquePropertyDescription,
      "is_all_inclusion_price": allInclusivePrice,
      "tax_excluded": taxAndGovtChargesExcluded,
      "is_negotiable": priceNegotiable,
      "ownership": ownerShip
    };

    final response = await postService.postRequest(
      url: urlWithResidentialIdStep3,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitStep4ResidentialImages({
    required int residentialPropertyId,
    required List<File> imageFiles,
  }) async {
    AppLogger.log("Number of imageFiles received: ${imageFiles.length}");
    if (imageFiles.isEmpty) {
      return {
        "success": false,
        "message": "No images selected.",
      };
    }

    final storage = GetStorage();
    int? residentialPropertyId = storage.read("residential_property_id");

    if (residentialPropertyId == null) {
      Get.snackbar(
          "Error", "PG Property ID not found. Please complete Step 3 first.",
          backgroundColor: AppColor.red);
      return {"status": 400, "message": "PG ID not found"};
    }

    String urlWithResidentialIdStep4 =
        "$propertyUploadImageUrl/$residentialPropertyId";
    AppLogger.log("Upload URL: $urlWithResidentialIdStep4");
    final response = await postService.postMultipleImagesRequest(
      url: urlWithResidentialIdStep4,
      imageFiles: imageFiles,
      requiresAuth: true,
    );
    AppLogger.log("Response from image upload: $response");
    return response;
  }
}

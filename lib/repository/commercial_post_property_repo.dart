import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../configs/app_color.dart';
import '../controller/commercial_post_property_controller.dart';

class CommercialPostPropertyRepo {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> submitStep1CommercialDetail() async {
    final CommercialPostPropertyController commercialPostPropertyController =
        Get.find<CommercialPostPropertyController>();

    final Map<String, dynamic> body =
        commercialPostPropertyController.buildCommercialPayload();

    final response = await postService.postRequest(
        url: commercialAddStep1Url, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitStep2CommercialDetail({
    required String city,
    required String area,
    required String subLocality,
    required String houseNo,
    required String pin,
  }) async {
    final storage = GetStorage();
    int commercialId = storage.read("commercial_id");
    // print("Repo Commercial ID ==>> $commercialId");
    if (commercialId == null) {
      Get.snackbar(
          "Error", "Commercial ID not found. Please complete Step 1 first.",
          backgroundColor: AppColor.red);
      return {"status": 400, "message": "Commercial ID not found"};
    }
    String urlWithCommercialIdStep2 = "$commercialAddStep2Url/$commercialId";

    Map<String, dynamic> body = {
      "city": city,
      "area": area,
      "sub_locality": subLocality,
      "house_no": houseNo,
      "pin": pin,
    };

    final response = await postService.postRequest(
      url: urlWithCommercialIdStep2,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitStep3CommercialDetail(
      {required int rentAmount,
      required String uniquePropertyDescription,
      required int allInclusivePrice,
      required int taxAndGovtChargesExcluded,
      required int priceNegotiable,
      required String ownerShip}) async {
    final storage = GetStorage();
    int? commercialId = storage.read("commercial_id");

    if (commercialId == null) {
      Get.snackbar("Error",
          "Commercial ID not found. Please complete Step 1 and Step 2 first.",
          backgroundColor: AppColor.red);
      return {"status": 400, "message": "Commercial ID not found"};
    }

    String urlWithCommercialIdStep3 = "$commercialAddStep3Url/$commercialId";

    Map<String, dynamic> body = {
      "rent_amount": rentAmount,
      "description": uniquePropertyDescription,
      "is_all_inclusion_price": allInclusivePrice,
      "tax_excluded": taxAndGovtChargesExcluded,
      "is_negotiable": priceNegotiable,
      "ownership": ownerShip
    };

    final response = await postService.postRequest(
      url: urlWithCommercialIdStep3,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitStep4CommercialImages({
    required int commercialPropertyId,
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
    int? commercialPropertyId = storage.read("commercial_property_id");

    if (commercialPropertyId == null) {
      Get.snackbar(
          "Error", " Property ID not found. Please complete Step 3 first.",
          backgroundColor: AppColor.red);
      return {"status": 400, "message": " ID not found"};
    }
    String urlWithCommercialIdStep4 =
        "$propertyUploadImageUrl/$commercialPropertyId";
    AppLogger.log("Upload URL: $urlWithCommercialIdStep4");
    final response = await postService.postMultipleImagesRequest(
      url: urlWithCommercialIdStep4,
      imageFiles: imageFiles,
      requiresAuth: true,
    );
    AppLogger.log("Response from image upload: $response");
    return response;
  }
}

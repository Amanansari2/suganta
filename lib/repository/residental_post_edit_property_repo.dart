import 'dart:io';

import 'package:get/get.dart';

import '../api_service/post_service.dart';
import '../api_service/putService.dart';
import '../api_service/url.dart';
import '../controller/residential_post_edit_property_controller.dart';

class ResidentialPostEditPropertyRepository {
  final PutService putService = Get.find<PutService>();
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> submitEditStep1ResidentialDetails() async {
    final ResidentialPostEditPropertyController
        residentialPostEditPropertyController =
        Get.find<ResidentialPostEditPropertyController>();

    final Map<String, dynamic> body =
        residentialPostEditPropertyController.buildEditResidentialPayload();
    final String url =
        "$residentialEditAddStep1Url/${residentialPostEditPropertyController.propertyLogId}";
    Get.log("Residential Edit Step 1 Url --->>$url");
    final response =
        await putService.putRequest(url: url, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitEditStep2ResidentialDetails({
    required int propertyLogId,
    required String city,
    required String area,
    required String subLocality,
    required String houseNo,
    required String pin,
  }) async {
    String urlWithResidentialIdStep2 =
        "$residentialEditAddStep2Url/$propertyLogId";

    Map<String, dynamic> body = {
      "city": city,
      "area": area,
      "sub_locality": subLocality,
      "house_no": houseNo,
      "pin": pin,
    };

    final response = await putService.putRequest(
      url: urlWithResidentialIdStep2,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> submitEditStep3ResidentialDetails(
      {required int propertyLogId,
      required int rentAmount,
      required String uniquePropertyDescription,
      required int allInclusivePrice,
      required int taxAndGovtChargesExcluded,
      required int priceNegotiable,
      required String ownerShip}) async {
    String urlWithResidentialIdStep3 =
        "$residentialEditAddStep3Url/$propertyLogId";

    Map<String, dynamic> body = {
      "rent_amount": rentAmount,
      "description": uniquePropertyDescription,
      "is_all_inclusion_price": allInclusivePrice,
      "tax_excluded": taxAndGovtChargesExcluded,
      "is_negotiable": priceNegotiable,
      "ownership": ownerShip
    };
    final response = await putService.putRequest(
      url: urlWithResidentialIdStep3,
      body: body,
      requiresAuth: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> uploadEditStep4Images({
    required int propertyImageId,
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
}

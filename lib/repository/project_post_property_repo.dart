import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../controller/project_post_property_controller.dart';

class ProjectPostPropertyRepo {
  final PostService postService = Get.find<PostService>();

  Future<Map<String, dynamic>> fetchProjectDropDownList() async {
    final response = await GetService.getRequest(
        url: getProjectDropDownUrl, requiresAuth: false);
    AppLogger.log("raw DropDown list -->>> $response");
    if (response["success"] == true) {
      return {"success": true, "data": response["data"]?["data"]};
    } else {
      return {"success": false, "message": response["data"]?["message"]};
    }
  }

  Future<Map<String, dynamic>> submitStep1ProjectDetail() async {
    final ProjectPostPropertyController projectPostPropertyController =
        Get.find<ProjectPostPropertyController>();

    final Map<String, dynamic> body =
        projectPostPropertyController.buildProjectPayload();

    final response = await postService.postRequest(
        url: projectAddStep1Url, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitStep2ProjectDetail({
    required String developerName,
    required String developerPhoneNumber1,
    required String developerPhoneNumber2,
    required String developerEmail1,
    required String developerEmail2,
    required String contactPersonName,
    required String contactPersonPhoneNumber,
    required String contactPersonEmail,
  }) async {
    final storage = GetStorage();
    int projectId = storage.read("project_id");
    if (projectId == null) {
      Get.snackbar(
        "Error",
        "Commercial ID not found. Please complete Step 1 first.",
      );
      return {"status": 400, "message": "Commercial ID not found"};
    }
    String urlWithProjectIdStep2 = "$projectAddStep2Url/$projectId";

    Map<String, dynamic> body = {
      "developer_name": developerName,
      "developer_ph_no1": developerPhoneNumber1,
      "developer_ph_no2": developerPhoneNumber2,
      "developer_email1": developerEmail1,
      "developer_email2": developerEmail2,
      "contact_person_no": contactPersonPhoneNumber,
      "contact_person_email": contactPersonEmail,
      "contact_person": contactPersonName
    };

    final response = await postService.postRequest(
        url: urlWithProjectIdStep2, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitStep3ProjectDetail({
    required String tokenAmount,
    required String propertyTax,
    required String maintenanceFee,
    required String additionalFee,
    required String priceRange,
    required String occupancyRate,
    required String annualRentalIncome,
    required String currentValuation,
  }) async {
    final storage = GetStorage();
    int? projectId = storage.read("project_id");
    if (projectId == null) {
      Get.snackbar(
        "Error",
        "Commercial ID not found. Please complete Step 1 and Step 2 first.",
      );
      return {"status": 400, "message": "Commercial ID not found"};
    }

    String urlWithProjectIdStep3 = "$projectAddStep3Url/$projectId";

    Map<String, dynamic> body = {
      "payment_schedule": tokenAmount,
      "property_tax_annual": propertyTax,
      "maintenance_fees": maintenanceFee,
      "additional_fees": additionalFee,
      "price_range": priceRange,
      "accupancy_rate": occupancyRate,
      "annual_rental_income": annualRentalIncome,
      "current_valuation": currentValuation
    };

    final response = await postService.postRequest(
        url: urlWithProjectIdStep3, body: body, requiresAuth: true);
    AppLogger.log("Project Step 3 Raw Response -->> $response");
    if (response["success"] == true) {
      String successMessage =
          response["data"]?["message"] ?? "Project Saved Successfully";
      return {
        "success": true,
        "message": successMessage,
        "data": response["data"]
      };
    } else {
      String errorMessage = _extractAllErrors(response["errors"]) ??
          response["message"] ??
          "Something Went Wrong! Please try again after sometime";

      AppLogger.log("Error message step 3 Project-->>> $errorMessage");
      return {"success": false, "message": errorMessage};
    }
  }

  Future<Map<String, dynamic>> submitStep4ProjectImages({
    required int projectPropertyId,
    required List<File> imageFiles,
  }) async {
    AppLogger.log("Number Of images Files Received: ${imageFiles.length}");

    if (imageFiles.isEmpty) {
      return {"success": false, "message": "No Images selected"};
    }
    final storage = GetStorage();
    int? projectPropertyId = storage.read("project_property_id");
    if (projectPropertyId == null) {
      Get.snackbar(
          "Error", "Property ID not found. Please complete Step 3 first.");

      return {"status": 400, "message": "Id Not Found"};
    }
    String urlWithProjectIdStep4 = "$projectUploadImageUrl/$projectPropertyId";
    AppLogger.log("Project Step4 Url -->>> $urlWithProjectIdStep4");
    final response = await postService.postMultipleImagesRequest(
        url: urlWithProjectIdStep4, imageFiles: imageFiles, requiresAuth: true);
    AppLogger.log("Response from Image upload : $response");
    return response;
  }

  String? _extractAllErrors(dynamic errors) {
    if (errors is Map<String, dynamic>) {
      List<String> messages = [];
      errors.forEach((key, value) {
        if (value is List) {
          for (var msg in value) {
            messages.add("$key: $msg");
          }
        }
      });
      return messages.isNotEmpty ? messages.join("\n") : null;
    }
    return null;
  }
}

import 'dart:io';

import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/putService.dart';
import '../api_service/url.dart';
import '../controller/project_post_edit_project_controller.dart';

class ProjectPostEditProjectRepo {
  final PostService postService = Get.find<PostService>();
  final PutService putService = Get.find<PutService>();

  Future<Map<String, dynamic>> fetchEditProjectDropDownList() async {
    final response = await GetService.getRequest(
        url: getProjectDropDownUrl, requiresAuth: true);

    if (response["success"] == true) {
      return {"success": true, "data": response["data"]?["data"]};
    } else {
      return {"success": false, "message": response["data"]?["message"]};
    }
  }

  Future<Map<String, dynamic>> submitEditStep1ProjectDetail() async {
    final ProjectPostEditProjectController projectPostEditProjectController =
        Get.find<ProjectPostEditProjectController>();

    final Map<String, dynamic> body =
        projectPostEditProjectController.buildProjectPayload();
    final String url =
        "$projectEditAddStep1Url/${projectPostEditProjectController.projectLogId}";
    AppLogger.log("Project Edit Step 1 url -->>>> $url");

    final response =
        await putService.putRequest(url: url, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitEditStep2ProjectDetail(
      {required int projectLogId,
      required String developerName,
      required String developerPhoneNumber1,
      required String developerPhoneNumber2,
      required String developerEmail1,
      required String developerEmail2,
      required String contactPersonName,
      required String contactPersonPhoneNumber,
      required String contactPersonEmail}) async {
    String urlWithProjectIdStep2 = "$projectEditAddStep2Url/$projectLogId";

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

    final response = await putService.putRequest(
        url: urlWithProjectIdStep2, body: body, requiresAuth: true);
    return response;
  }

  Future<Map<String, dynamic>> submitEditStep3ProjectDetail({
    required int projectLogId,
    required String tokenAmount,
    required String propertyTax,
    required String maintenanceFee,
    required String additionalFee,
    required String priceRange,
    required String occupancyRate,
    required String annualRentalIncome,
    required String currentValuation,
  }) async {
    String urlWithProjectIdStep3 = "$projectEditAddStep3Url/$projectLogId";

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

    final response = await putService.putRequest(
        url: urlWithProjectIdStep3, body: body, requiresAuth: true);

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

  Future<Map<String, dynamic>> submitEditStep4ProjectDetail({
    required int projectImageId,
    required List<File> imageFiles,
  }) async {
    AppLogger.log("Number Of images Files Received: ${imageFiles.length}");
    if (imageFiles.isEmpty) {
      return {
        "success": false,
        "message": "No images selected.",
      };
    }

    String urlWithProjectIdStep4 = "$projectUploadImageUrl/$projectImageId";
    final response = await postService.postMultipleImagesRequest(
        url: urlWithProjectIdStep4, imageFiles: imageFiles, requiresAuth: true);
    AppLogger.log("Response from Image upload : $response");
    return response;
  }

  Future<Map<String, dynamic>> deleteMultipleProjectImages({
    required int projectId,
    required List<int> imageIds,
  }) async {
    final body = {
      "project_id": projectId,
      "img_id": imageIds.join(","),
    };

    final response = await postService.postRequest(
        url: projectDeleteImageUrl, body: body, requiresAuth: true);

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

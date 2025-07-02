import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tytil_realty/controller/profile_controller.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../configs/app_color.dart';
import '../model/login_model.dart';
import '../repository/update _credentials_repo.dart';

class UpdateCredentialsController extends GetxController {
  UpdateCredentialRepository updateCredentialRepository =
      Get.find<UpdateCredentialRepository>();
  final ProfileController profileController = Get.find<ProfileController>();

  RxBool hasPhoneNumberFocus = false.obs;
  RxBool hasPhoneNumberInput = false.obs;
  FocusNode phoneNumberFocusNode = FocusNode();
  TextEditingController phoneNumberController = TextEditingController();

  RxBool hasEmailFocus = false.obs;
  RxBool hasEmailInput = false.obs;
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  RxBool hasPasswordFocus = false.obs;
  RxBool hasPasswordInput = false.obs;
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  RxBool hasConfirmPasswordFocus = false.obs;
  RxBool hasConfirmPasswordInput = false.obs;
  FocusNode confirmPasswordFocusNode = FocusNode();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> updateCredentials() async {
    Map<String, dynamic> body = {};

    if (phoneNumberController.text.trim().isEmpty &&
        emailController.text.trim().isEmpty &&
        phoneNumberController.text.isEmpty &&
        confirmPasswordController.text.isEmpty) {
      Get.rawSnackbar(
          title: "Error",
          message: "At least one field is required to update credentials.",
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (phoneNumberController.text.trim().isNotEmpty &&
        (phoneNumberController.text.trim().length < 10 ||
            phoneNumberController.text.trim().length > 15)) {
      Get.rawSnackbar(
          title: "Error",
          message: "Phone number must be between 10 to 15 digits.",
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isEmpty) {
      Get.rawSnackbar(
          title: "Error",
          message: "Confirm password is required when changing password.",
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      Get.rawSnackbar(
        title: "Error",
        message: "Password and Confirm Password must match.",
        backgroundColor: AppColor.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (phoneNumberController.text.trim().isNotEmpty) {
      body["phone"] = phoneNumberController.text.trim();
    }

    if (emailController.text.trim().isNotEmpty) {
      body["email"] = emailController.text.trim();
    }

    if (passwordController.text.isNotEmpty) {
      body["password"] = passwordController.text;
    }
    if (confirmPasswordController.text.isNotEmpty) {
      body["password_confirmation"] = confirmPasswordController.text;
    }

    AppLogger.log("Sending request....");
    AppLogger.log("Request body -->>> $body");

    final response = await updateCredentialRepository.updateCredentials(body);

    if (response["success"] == true) {
      Get.rawSnackbar(
          title: "Success",
          message: response["message"],
          backgroundColor: AppColor.green,
          snackPosition: SnackPosition.TOP);
      await fetchAndUpdateProfile();
    } else {
      String errorMessage = response["message"] ?? "Something went wrong";

      AppLogger.log("Extracted Error Message -->>> $errorMessage");
      Get.rawSnackbar(
          title: "Error",
          message: errorMessage,
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> fetchAndUpdateProfile() async {
    final response =
        await GetService.getRequest(url: getUserProfileUrl, requiresAuth: true);

    if (response["success"] == true && response.containsKey("data")) {
      final userData = response["data"];
      profileController.storage.write("user_data", userData);
      profileController.user.value = LoginModel.fromJson(userData);
      AppLogger.log(" Profile updated in GetStorage: $userData");
    } else {
      AppLogger.log(
          " Failed to update GetStorage with latest profile. Response -->> $response");
    }
  }

  @override
  void onInit() {
    super.onInit();

    phoneNumberFocusNode.addListener(() {
      hasPhoneNumberFocus.value = phoneNumberFocusNode.hasFocus;
    });

    phoneNumberController.addListener(() {
      hasPhoneNumberInput.value = phoneNumberController.text.isNotEmpty;
    });

    emailFocusNode.addListener(() {
      hasEmailFocus.value = emailFocusNode.hasFocus;
    });

    emailController.addListener(() {
      hasEmailInput.value = emailController.text.isNotEmpty;
    });

    passwordFocusNode.addListener(() {
      hasPasswordFocus.value = passwordFocusNode.hasFocus;
    });

    passwordController.addListener(() {
      hasPasswordInput.value = passwordController.text.isNotEmpty;
    });

    confirmPasswordFocusNode.addListener(() {
      hasConfirmPasswordFocus.value = confirmPasswordFocusNode.hasFocus;
    });

    confirmPasswordController.addListener(() {
      hasConfirmPasswordInput.value = confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    super.onClose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

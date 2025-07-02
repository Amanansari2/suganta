import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../repository/contact_us_repo.dart';

class ContactUsController extends GetxController {
  final ContactUsRepository contactUsRepository =
      Get.find<ContactUsRepository>();

  RxBool hasFullNameFocus = false.obs;
  RxBool hasFullNameInput = false.obs;
  RxBool hasPhoneNumberFocus = false.obs;
  RxBool hasPhoneNumberInput = false.obs;
  RxBool hasEmailFocus = false.obs;
  RxBool hasEmailInput = false.obs;
  FocusNode focusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  bool validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      Get.rawSnackbar(
          title: "Error",
          message: "Full name is required!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red);

      return false;
    }

    if (phoneNumberController.text.trim().isEmpty) {
      Get.rawSnackbar(
          title: "Error",
          message: "Phone number is Required!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red);

      return false;
    }

    if (phoneNumberController.length < 10 ||
        phoneNumberController.length > 15) {
      Get.rawSnackbar(
        title: "Error",
        message: "Phone number must be between 10 and 15 digits!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email is Required!");
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text)) {
      Get.rawSnackbar(
        title: "Error",
        message: "Enter a valid email address!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
      );
      return false;
    }

    if (messageController.text.trim().isEmpty) {
      Get.snackbar("Error", "Message is Required!");
      return false;
    }

    return true;
  }

  void clearForm() {
    fullNameController.clear();
    phoneNumberController.clear();
    emailController.clear();
    messageController.clear();
  }

  RxBool isLoading = false.obs;

  Future<void> contactUs() async {
    if (!validateInputs()) return;

    isLoading(true);

    final response = await contactUsRepository.contactUs(
        name: fullNameController.text,
        phone: phoneNumberController.text,
        email: emailController.text.trim(),
        message: messageController.text);

    isLoading(false);
    if (response["success"] == true) {
      final successMessage = response["message"] ?? "Submitted successfully!";
      AppLogger.log("Contact Us message: $successMessage");
      clearForm();

      Get.rawSnackbar(
          title: successMessage,
          message: successMessage,
          backgroundColor: AppColor.green,
          snackPosition: SnackPosition.TOP);
    } else {
      Get.rawSnackbar(
          title: "Error",
          message: response["message"],
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      hasFullNameFocus.value = focusNode.hasFocus;
    });
    phoneNumberFocusNode.addListener(() {
      hasPhoneNumberFocus.value = phoneNumberFocusNode.hasFocus;
    });
    emailFocusNode.addListener(() {
      hasEmailFocus.value = emailFocusNode.hasFocus;
    });
    fullNameController.addListener(() {
      hasFullNameInput.value = fullNameController.text.isNotEmpty;
    });
    phoneNumberController.addListener(() {
      hasPhoneNumberInput.value = phoneNumberController.text.isNotEmpty;
    });
    emailController.addListener(() {
      hasEmailInput.value = emailController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    focusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/app_color.dart';
import '../configs/app_string.dart';
import '../model/register_model.dart';
import '../repository/register_repo.dart';
import '../routes/app_routes.dart';

class RegisterController extends GetxController {
  final RegisterRepo repository = Get.find<RegisterRepo>();
  RxBool hasFullNameFocus = false.obs;
  RxBool hasFullNameInput = false.obs;
  RxBool hasPhoneNumberFocus = false.obs;
  RxBool hasPhoneNumberInput = false.obs;
  RxBool hasEmailFocus = false.obs;
  RxBool hasEmailInput = false.obs;
  RxBool hasPasswordFocus = false.obs;
  RxBool hasPasswordInput = false.obs;
  RxBool hasConfirmPasswordFocus = false.obs;
  RxBool hasConfirmPasswordInput = false.obs;
  RxBool hasOtpFocus = false.obs;
  RxBool hasOtpInput = false.obs;
  FocusNode focusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  RxInt selectOption = 0.obs;
  RxBool isChecked = false.obs;

  RxBool isLoading = false.obs;
  RegisterModel? user;

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
    passwordFocusNode.addListener(() {
      hasPasswordFocus.value = passwordFocusNode.hasFocus;
    });
    confirmPasswordFocusNode.addListener(() {
      hasConfirmPasswordFocus.value = confirmPasswordFocusNode.hasFocus;
    });
    otpFocusNode.addListener(() {
      hasOtpFocus.value = otpFocusNode.hasFocus;
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
    passwordController.addListener(() {
      hasPasswordInput.value = passwordController.text.isNotEmpty;
    });
    confirmPasswordController.addListener(() {
      hasConfirmPasswordInput.value = confirmPasswordController.text.isNotEmpty;
    });
    otpController.addListener(() {
      hasOtpInput.value = otpController.text.isNotEmpty;
    });
  }

  void updateOption(int index) {
    selectOption.value = index;
  }

  void toggleCheckbox() {
    isChecked.toggle();
  }

  RxList<String> optionList = [
    AppString.yes,
    AppString.no,
  ].obs;

  RxBool isOtpStep = false.obs;

  Future<void> registerUser() async {
    if (!validateInputs()) return;

    isLoading(true);
    final response = await repository.registerUser(
        role: 5,
        name: fullNameController.text.trim(),
        phone: phoneNumberController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text);
    isLoading(false);

    String message =
        response["message"] ?? "Registration completed successfully";

    if (response["success"] == true) {
      user = response["user"];

      Get.rawSnackbar(
          title: "success",
          message: message,
          backgroundColor: AppColor.green,
          snackPosition: SnackPosition.TOP);

      isOtpStep(true);
    } else {
      Get.rawSnackbar(
          title: "Error",
          message: response["message"],
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> verifyOtpAndRegisterUser() async {
    if (!validateInputs() || otpController.text.trim().isEmpty) {
      Get.rawSnackbar(
        title: "Error",
        message: "Please enter OTP",
        backgroundColor: AppColor.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading(true);
    final response = await repository.verifyOtpAndRegister(
      role: 5,
      name: fullNameController.text.trim(),
      phone: phoneNumberController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      otp: otpController.text.trim(),
    );
    isLoading(false);

    String message = response["message"] ?? "Verification complete";

    if (response["success"] == true) {
      user = response["user"];
      Get.rawSnackbar(
        title: "Success",
        message: message,
        backgroundColor: AppColor.green,
        snackPosition: SnackPosition.TOP,
      );
      Future.delayed(const Duration(seconds: 2)).then((_) {
        Get.offNamed(AppRoutes.loginView);
      });
    } else {
      Get.rawSnackbar(
        title: "Error",
        message: response["message"],
        backgroundColor: AppColor.red,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  bool validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      Get.rawSnackbar(
          title: "Error",
          message: "Full name is required!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red);

      //  Get.snackbar("Error", "Phone number is Required!");
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

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email is Required!");
      return false;
    }

    if (passwordController.text.length < 8) {
      Get.rawSnackbar(
          title: "Error",
          message: "Password must be at least 8 character!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red);

      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.rawSnackbar(
          title: "Error",
          message: "Password does not match!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red);

      return false;
    }
    return true;
  }

  @override
  void onClose() {
    focusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpFocusNode.dispose();
    otpController.dispose();
    super.onClose();
  }
}

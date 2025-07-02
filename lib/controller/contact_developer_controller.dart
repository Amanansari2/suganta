import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:tytil_realty/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../repository/contact_developer_repo.dart';

class ContactDeveloperController extends GetxController {
  final int projectId;

  ContactDeveloperController(this.projectId) {
    AppLogger.log(
        "ContactDeveloperController initialized with project id -->> $projectId");
  }

  final ContactDeveloperRepository contactDeveloperRepository =
      Get.find<ContactDeveloperRepository>();



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
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RxBool hasOtpFocus = false.obs;
  RxBool hasOtpInput = false.obs;
  FocusNode otpFocusNode = FocusNode();
  TextEditingController otpController = TextEditingController();

  RxBool isContactDeveloperLoading = false.obs;
  RxBool isVerifyOtpLoading = false.obs;

  RxBool isOtpStep = false.obs;

  RxBool isVerified = false.obs;

  RxBool isLeadStatus = false.obs;

  bool validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Full name is required!",
      );
      return false;
    }

    if (mobileNumberController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number is Required!",
      );

      return false;
    }

    if (mobileNumberController.length < 10 ||
        mobileNumberController.length > 15) {
      Get.snackbar(
        "Error",
        "Phone number must be between 10 and 15 digits.",
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email is Required!");
      return false;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Invalid email format!",
      );
      return false;
    }
    return true;
  }

  Future<void> contactDeveloper() async {
    if (!validateInputs()) return;

    isContactDeveloperLoading(true);

    final storage = GetStorage();
    final isLoggedIn = storage.read("isLoggedIn") ?? false;
    final token = storage.read("auth_token") ?? "";

    final response = await contactDeveloperRepository.contactDeveloper(
        name: fullNameController.text,
        phone: mobileNumberController.text.trim(),
        email: emailController.text,
        projectId: projectId,
        token: isLoggedIn ? token : null
    );

    isContactDeveloperLoading(false);

    final responseMessage = response["message"]?.toString() ?? "otp sent";
    const List<String> redirectMessages = [
      "Your lead limit has been completed. Please top up your wallet.",
      "Low Balance. Please top up your wallet."
    ];

    if(redirectMessages.contains(responseMessage)){
      if(!isLoggedIn){
        Get.snackbar("Notice", "To view more details, please log in — your free limit has been reached.");
        showFullscreenLoader();
        await Future.delayed(const Duration(seconds: 4));
        hideFullscreenLoader();
        Get.offAllNamed(AppRoutes.loginView);
      }else {
        Get.snackbar("Notice", responseMessage);
        showFullscreenLoader();
        await Future.delayed(const Duration(seconds: 4));
        await launchUrl(
            Uri.parse("https://www.tytil.com/payment/topup"),
            mode: LaunchMode.externalApplication
        );

        hideFullscreenLoader();
      }
      return;
    }

    String message = response["message"] ?? "Otp Sent";
    AppLogger.log("Contact Developer Otp Message -->> $message");

    int leadStatus = response["lead_status"] ?? 0;
    AppLogger.log("First Step lead status -->>> $leadStatus");
    if (response["success"] == true) {
      Get.snackbar(
        "success",
        message,
      );
      if (leadStatus == 0) {
        isOtpStep(true);
      } else {
        isVerified(true);
      }
    } else {
      Get.snackbar(
        "Error",
        response["message"],
      );
    }
  }

  void showFullscreenLoader() {
    Get.dialog(
      const Center(
        child: SpinKitCircle(
            size: 100,
            color: AppColor.primaryColor),
      ),
      barrierDismissible: false,
    );
  }

  void hideFullscreenLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }


  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter OTP",
      );
      return;
    }

    isVerifyOtpLoading(true);

    final response = await contactDeveloperRepository.verifyOtp(
        name: fullNameController.text.trim(),
        phone: mobileNumberController.text.trim(),
        email: emailController.text.trim(),
        projectId: projectId,
        otp: int.tryParse(otpController.text.trim()) ?? 0);
    isVerifyOtpLoading(false);
    String message = response["message"] ?? "Verification Complete";
    int leadStatus = response["lead_status"];
    AppLogger.log("Developer lead Status -->> $leadStatus");
    if (response["success"] == true) {
      if (leadStatus == 1) {
        isVerified(true);
        isOtpStep(false);
      }

      Get.snackbar(
        "Success",
        message,
      );
    } else {
      Get.snackbar(
        "Error",
        response["message"],
      );
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
    mobileNumberController.addListener(() {
      hasPhoneNumberInput.value = mobileNumberController.text.isNotEmpty;
    });
    emailController.addListener(() {
      hasEmailInput.value = emailController.text.isNotEmpty;
    });

    otpFocusNode.addListener(() {
      hasOtpFocus.value = otpFocusNode.hasFocus;
    });

    otpController.addListener(() {
      hasOtpInput.value = otpController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    otpFocusNode.dispose();
    otpController.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/controller/wishlist_controller.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../model/login_model.dart';
import '../repository/login_repo.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final LoginRepository repository = Get.find<LoginRepository>();
  final storage = GetStorage();

  var isPasswordHidden = true.obs;

  RxBool isLoading = false.obs;
  RxBool hasMobileFocus = false.obs;
  RxBool hasMobileInput = false.obs;
  FocusNode mobileFocusNode = FocusNode();
  TextEditingController mobileController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  RxBool hasPasswordFocus = false.obs;
  RxBool hasPasswordInput = false.obs;
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  RxBool hasEmailFocus = false.obs;
  RxBool hasEmailInput = false.obs;
  TextEditingController emailController = TextEditingController();

  LoginModel? user;

  @override
  void onInit() {
    super.onInit();
    startCooldownTimer();
    mobileFocusNode.addListener(() {
      hasMobileFocus.value = mobileFocusNode.hasFocus;
    });
    mobileController.addListener(() {
      hasMobileInput.value = mobileController.text.isNotEmpty;
    });
    passwordFocusNode.addListener(() {
      hasPasswordFocus.value = passwordFocusNode.hasFocus;
    });

    passwordController.addListener(() {
      hasPasswordInput.value = passwordController.text.isNotEmpty;
    });

    emailFocusNode.addListener(() {
      hasEmailFocus.value = emailFocusNode.hasFocus;
    });

    emailController.addListener(() {
      hasEmailInput.value = emailController.text.isNotEmpty;
    });
  }

  Future<void> loginUser() async {
    if (isLoading.value) return;

    if (mobileController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email/Number  is required",
      );

      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Password  is required",
      );
      return;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
        "Error",
        "Password must be at least 8 characters long",
      );
      return;
    }

    isLoading(true);
    try {
      final response = await repository.loginUser(
          login: mobileController.text.trim(),
          password: passwordController.text);

      final message =
          response["message"]?.toString(); //?? "unexpected error occurred";

      if (response["success"] == true) {
        user = response["user"];
        storage.write("isLoggedIn", true);
        storage.write("auth_token", user!.token);
        storage.write("user_data", user!.toJson());

        AppLogger.log("Stored User Data: ${storage.read("user_data")}");
        AppLogger.log("Stored Auth Token: ${storage.read("auth_token")}");

        await Get.find<WishlistController>().fetchWishlistAfterLogin();
        await Get.find<WishlistController>().fetchProjectWishlistAfterLogin();

        Get.snackbar(
          "Success",
          message!,
        );

        Get.offAllNamed(AppRoutes.bottomBarView);
      } else {
        String errorMessage = response["message"] ?? "Something went wrong";

        AppLogger.log(" UI Message: $errorMessage");

        Get.snackbar(
          "Error",
          errorMessage,
        );
      }
    } catch (e) {
      AppLogger.log("Exception caught login -- $e");
      Get.snackbar("Error", "Something Went Wrong, Please try again");
    } finally {
      isLoading(false);
    }
  }

  Future<void> forgotPassword() async {
    final now = DateTime.now();
    Get.log("Current Time -->> $now");
    final lastSent = storage.read('last_sent_time');
    final lastTapDate = storage.read('last_tap_date');
    final today = "${now.year}-${now.month}-${now.day}";
    Get.log("Today -->> $today, Last Tap Date $lastTapDate");

    if (lastTapDate != today) {
      Get.log("New Day Selected Resetting Tap Count");

      storage.write('daily_tap_count', 0);
      storage.write('last_tap_date', today);
    }
    final tapCount = storage.read('daily_tap_count') ?? 0;
    Get.log("Current Tap Count $tapCount");

    if (tapCount >= 3) {
      Get.log("Tap Count Limit Reached for Toady");

      Get.rawSnackbar(
        title: "Limit Reached",
        message: "You can request reset link only 3 times per day.",
        backgroundColor: AppColor.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (lastSent != null) {
      final last = DateTime.tryParse(lastSent);
      Get.log("Last Sent Time -->> $last");

      if (last != null && now.difference(last).inMinutes < 30) {
        final remaining = 30 - now.difference(last).inMinutes;
        Get.log("Still in cooldown: $remaining minute(s) left.");
        Get.rawSnackbar(
          title: "Please wait",
          message:
              "Try again after ${30 - now.difference(last).inMinutes} minutes.",
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    }

    if (emailController.text.isEmpty) {
      Get.rawSnackbar(
          title: "Error",
          message: "Email is required",
          backgroundColor: AppColor.red,
          snackPosition: SnackPosition.TOP);
      return;
    }
    isLoading(true);
    final response =
        await repository.forgetPassword(email: emailController.text);
    isLoading(false);

    if (response["success"] == true) {
      String message =
          response["message"]?.toString() ?? "Something went wrong";
      Get.log("✅ Request successful. Saving state...");
      storage.write('last_sent_time', now.toIso8601String());
      storage.write('daily_tap_count', tapCount + 1);
      startCooldownTimer();

      Get.log("message -->> $message");

      Get.rawSnackbar(
          title: "Success",
          message: message,
          backgroundColor: AppColor.green,
          snackPosition: SnackPosition.TOP);
      emailController.clear();
      Get.toNamed(AppRoutes.loginView);
    } else {
      String errorMessage =
          response["message"]?.toString() ?? "Something went wrong";
      Get.snackbar(
        "Error",
        errorMessage,
      );
    }
  }

  Rx<Duration?> cooldownDuration = Rx<Duration?>(null);
  Timer? _cooldownTimer;

  void startCooldownTimer() {
    final lastSent = storage.read('last_sent_time');
    if (lastSent == null) {
      cooldownDuration.value = null;
      return;
    }

    final last = DateTime.tryParse(lastSent);
    if (last == null) {
      cooldownDuration.value = null;
      return;
    }

    final now = DateTime.now();
    final difference = now.difference(last);
    final remaining = const Duration(minutes: 30) - difference;

    if (remaining.isNegative) {
      cooldownDuration.value = null;
      return;
    }

    cooldownDuration.value = remaining;

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final updated = cooldownDuration.value! - const Duration(seconds: 1);
      if (updated.inSeconds <= 0) {
        cooldownDuration.value = null;
        timer.cancel();
      } else {
        cooldownDuration.value = updated;
      }
    });
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel();

    mobileFocusNode.dispose();
    passwordFocusNode.dispose();
    mobileController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    emailController.dispose();

    super.onClose();
  }
}

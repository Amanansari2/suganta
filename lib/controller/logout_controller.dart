import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/controller/profile_controller.dart';

import '../api_service/print_logger.dart';
import '../configs/app_color.dart';
import '../repository/logout_repo.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';
import 'login_controller.dart';

class LogoutController extends GetxController {
  final LogoutRepository logoutRepository = Get.find<LogoutRepository>();
  final ProfileController profileController = Get.find<ProfileController>();
  final GetStorage storage = GetStorage();
  RxBool isLoggingOut = false.obs;

  RxString selectedLogoutOption = ''.obs;

  Future<void> logout({required bool allDevices}) async {
    selectedLogoutOption.value = allDevices ? 'all' : 'current';
    isLoggingOut(true);

    final response = await logoutRepository.logoutUser(allDevices: allDevices);

    isLoggingOut(false);
    selectedLogoutOption.value = '';
    AppLogger.log("Logout API Response: $response");

    if (response["success"] == true) {
      Get.back();

      storage.remove("auth_token");
      storage.remove("isLoggedIn");
      storage.remove("user_data");

      profileController.user.value = null;
      profileController.user.refresh();

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().postPropertyList.clear();
        Get.find<HomeController>().paginatedPostProject.clear();
      }

      AppLogger.log("Logout successful, navigating to login");

      Get.delete<LoginController>(force: true);
      Get.delete<LogoutController>(force: true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.loginView);
        // Get.toNamed(AppRoutes.loginView);
      });
      Get.rawSnackbar(
          title: "Success",
          message: response["message"],
          backgroundColor: AppColor.green,
          snackPosition: SnackPosition.TOP);
    } else {
      AppLogger.log("Logout failed: Unexpected error");
      Get.rawSnackbar(
          title: "Error",
          message: "Unexpected Error, Please try Again after some time.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red);
    }
  }
}

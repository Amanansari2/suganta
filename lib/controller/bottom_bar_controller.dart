import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api_service/print_logger.dart';
import '../configs/app_size.dart';
import '../configs/app_string.dart';
import '../gen/assets.gen.dart';
import '../model/login_model.dart';

class BottomBarController extends GetxController {
  RxInt selectIndex = 0.obs;
  late PageController pageController = PageController();
  bool isInitialized = false;

  final storage = GetStorage();
  LoginModel? user;

  @override
  void onInit() {
    super.onInit();
    initPageController();
    fetchUserData();
    //  pageController = PageController(initialPage: AppSize.size0);
  }

  void fetchUserData() {
    if (storage.hasData("user_data")) {
      var userData = storage.read("user_data");

      AppLogger.log("Retrieved from GetStorage: $userData");
      AppLogger.log("User Data Type: ${userData.runtimeType}");

      if (userData != null) {
        try {
          if (userData is! Map<String, dynamic>) {
            userData = Map<String, dynamic>.from(userData);
          }
          AppLogger.log("Converting userData to LoginModel...");
          user = LoginModel.fromJson(userData);
          AppLogger.log("User successfully parsed!");
          user = LoginModel.fromJson(userData);
          printUserData();
        } catch (e, stackTrace) {
          AppLogger.log("Error parsing user data: $e");
          AppLogger.log("🔍 Stack Trace: $stackTrace");
        }
      } else {
        AppLogger.log("Stored user data is null.");
      }
    } else {
      AppLogger.log("No user data found in GetStorage.");
    }
  }

  void printUserData() {
    if (user != null) {
      AppLogger.log("User Data Retrieved:");
      AppLogger.log("ID: ${user!.id}");
      AppLogger.log("Role: ${user!.role}");
      AppLogger.log("Name: ${user!.name}");
      AppLogger.log("Image: ${user!.image}");
      AppLogger.log("DOB: ${user!.dob}");
      AppLogger.log("Gender: ${user!.gender}");
      AppLogger.log("Email: ${user!.email}");
      AppLogger.log("Phone: ${user!.phone}");
      AppLogger.log("Bank ID: ${user!.bankId}");
      AppLogger.log("Logo: ${user!.logo}");
      AppLogger.log("Email Verified At: ${user!.emailVerifiedAt}");
      AppLogger.log("Status: ${user!.status}");
      AppLogger.log("Created At: ${user!.createdAt}");
      AppLogger.log("Updated At: ${user!.updatedAt}");
      AppLogger.log("User ID: ${user!.userId}");
      AppLogger.log("Token: ${user!.token}");
    }
  }

  void initPageController() {
    pageController = PageController(initialPage: AppSize.size0);
  }

  void updateIndex(int index) {
    selectIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  RxList<String> bottomBarImageList = [
    Assets.images.home.path,
    Assets.images.task.path,
    '',
    // Assets.images.save.path,
    Assets.images.user.path,
  ].obs;

  RxList<String> bottomBarMenuNameList = [
    AppString.home,
    AppString.activity,
    '',
    //AppString.saved,
    AppString.profile,
  ].obs;
}

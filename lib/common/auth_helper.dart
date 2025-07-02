import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../common/custom_dialog.dart';
import '../configs/app_color.dart';
import '../controller/bottom_bar_controller.dart';
import '../gen/assets.gen.dart';
import '../routes/app_routes.dart';

class AuthHelper {
  static final GetStorage _storage = GetStorage();

  static bool checkAuthAndProceed(BuildContext context, {VoidCallback? onAuthenticated}) {
    final String? token = _storage.read("auth_token");

    if (token == null || token.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: AppColor.black.withOpacity(0.3),
              ),
              ),
          Center(
          child: WillPopScope(
          onWillPop: () async => false,
          child: CustomDialog(
          title: "Login Required",
          description: "Please login first to continue.",
          buttonText: "OK",
          image: Assets.images.add.path,
          onConfirm: () {
            final bottomBarController = Get.find<BottomBarController>();
            bottomBarController.pageController.jumpToPage(0);
            bottomBarController.updateIndex(0);
          Get.toNamed(AppRoutes.loginView);
          },
          ),
          ),
          )

            ],
          );

        },
      );
      return false;
    }


    if (onAuthenticated != null) {
      onAuthenticated();
    }

    return true;
  }
  static bool isLoggedIn() {
    final String? token = _storage.read("auth_token");
    return token != null && token.isNotEmpty;
  }
}

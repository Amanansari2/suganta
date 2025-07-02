import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/logout_controller.dart';

logoutBottomSheet(BuildContext context) {
  final LogoutController logoutController = Get.find<LogoutController>();

  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    shape: const OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppSize.appSize12),
        topRight: Radius.circular(AppSize.appSize12),
      ),
      borderSide: BorderSide.none,
    ),
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: AppSize.appSize250,
        padding: const EdgeInsets.only(
          top: AppSize.appSize26,
          bottom: AppSize.appSize20,
          left: AppSize.appSize16,
          right: AppSize.appSize16,
        ),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.appSize12),
            topRight: Radius.circular(AppSize.appSize12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.logout,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Text(
                  AppString.logoutString,
                  style: AppStyle.heading5Regular(
                      color: AppColor.descriptionColor),
                ).paddingOnly(top: AppSize.appSize6),
                const SizedBox(height: AppSize.appSize20),
                _logoutOptionTile(
                  title: "Logout from this device",
                  onTap: () async {
                    await logoutController.logout(allDevices: false);
                  },
                  optionKey: 'current',
                  logoutController: logoutController,
                ),
                const SizedBox(height: AppSize.appSize12),
                _logoutOptionTile(
                  title: "Logout from all devices",
                  onTap: () async {
                    await logoutController.logout(allDevices: true);
                  },
                  optionKey: 'all',
                  logoutController: logoutController,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _logoutOptionTile({
  required String title,
  required VoidCallback onTap,
  required LogoutController logoutController,
  required String optionKey,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Obx(() => Container(
          height: AppSize.appSize49,
          padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyle.heading3Medium(color: AppColor.primaryColor),
              ),
              logoutController.isLoggingOut.value &&
                      logoutController.selectedLogoutOption.value == optionKey
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryColor,
                      ),
                    )
                  : FaIcon(
                      logoutController.selectedLogoutOption.value == optionKey
                          ? FontAwesomeIcons.solidCircle
                          : FontAwesomeIcons.circle,
                      color: AppColor.primaryColor,
                      size: 18,
                    ),
            ],
          ),
        )),
  );
}

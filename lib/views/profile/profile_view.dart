import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tytil_realty/views/profile/widgets/delete_account_bottom_sheet.dart';
import 'package:tytil_realty/views/profile/widgets/finding_us_helpful_bottom_sheet.dart';
import 'package:tytil_realty/views/profile/widgets/logout_bottom_sheet.dart';

import '../../api_service/app_config.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/bottom_bar_controller.dart';
import '../../controller/profile_controller.dart';
import '../../controller/translation_controller.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  ProfileController profileController = Get.find<ProfileController>();
  TranslationController translationController =
      Get.put(TranslationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildProfile(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSize.appSize16),
        child: GestureDetector(
          onTap: () {
            BottomBarController bottomBarController =
                Get.put(BottomBarController());
            bottomBarController.pageController.jumpToPage(AppSize.size0);
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Obx(() => Text(
            translationController.translate(AppString.profile),
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          )),
    );
  }

  Widget buildProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // Image.asset(
                  //   Assets.images.francisProfile.path,
                  //   width: AppSize.appSize68,
                  // ).paddingOnly(right: AppSize.appSize16),
                  Obx(() {
                    final image = profileController.user.value?.image;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.appSize34),
                      child: image != null && image.isNotEmpty
                          ? Image.network(
                              "${AppConfigs.mediaUrl}$image?path=Profile",
                              width: AppSize.appSize68,
                              height: AppSize.appSize68,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Image.asset(
                                  "assets/myImg/unknown_user.png",
                                  width: AppSize.appSize68,
                                  height: AppSize.appSize68,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/myImg/unknown_user.png",
                              width: AppSize.appSize68,
                              height: AppSize.appSize68,
                            ),
                    );
                  }).paddingOnly(right: AppSize.appSize16),

                  Expanded(
                    child: Obx(() => Text(
                          profileController.user.value?.name ?? "Unknown user",
                          style: AppStyle.heading3Medium(
                              color: AppColor.textColor),
                        )),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.editProfileView);
              },
              child: Obx(() => Text(
                    translationController.translate(AppString.editProfile),
                    style:
                        AppStyle.heading5Medium(color: AppColor.primaryColor),
                  )),
            ),
          ],
        ),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: AppSize.appSize36),
            itemCount: profileController.profileOptionImageList.length,
            itemBuilder: (context, index) {
              if (!profileController.profileOptionTitle[index])
                return const SizedBox.shrink();

              return GestureDetector(
                onTap: () {
                  if (index == AppSize.size0) {
                    Get.toNamed(AppRoutes.postPropertyView);
                  } else if (index == AppSize.size1) {
                    Get.toNamed(AppRoutes.responsesView);
                  } else if (index == AppSize.size2) {
                    Get.toNamed(AppRoutes.languagesView);
                  } else if (index == AppSize.size3) {
                    Get.toNamed(AppRoutes.communitySettingsView);
                  } else if (index == AppSize.size4) {
                    Get.toNamed(AppRoutes.privacyPolicyView);
                  } else if (index == AppSize.size5) {
                    Get.toNamed(AppRoutes.termsOfUseView);
                  } else if (index == AppSize.size6) {
                    Get.toNamed(AppRoutes.contactUsView);
                  } else if (index == AppSize.size7) {
                    findingUsHelpfulBottomSheet(context);
                  } else if (index == AppSize.size8) {
                    logoutBottomSheet(context);
                  } else if (index == AppSize.size9) {
                    deleteAccountBottomSheet(context);
                  }
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          profileController.profileOptionImageList[index],
                          width: AppSize.appSize20,
                        ).paddingOnly(right: AppSize.appSize12),
                        Obx(() => Text(
                              translationController.translate(profileController
                                  .profileOptionTitleList[index]),
                              style: AppStyle.heading5Regular(
                                  color: AppColor.textColor),
                            )),
                      ],
                    ),
                    if (index <
                        profileController.profileOptionImageList.length -
                            AppSize.size1) ...[
                      Divider(
                        color: AppColor.descriptionColor
                            .withOpacity(AppSize.appSizePoint4),
                        height: AppSize.appSize0,
                        thickness: AppSize.appSizePoint7,
                      ).paddingOnly(
                          top: AppSize.appSize16, bottom: AppSize.appSize26),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).paddingOnly(
      top: AppSize.appSize10,
      left: AppSize.appSize16,
      right: AppSize.appSize16,
    );
  }
}

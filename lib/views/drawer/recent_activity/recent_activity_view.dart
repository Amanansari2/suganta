import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/recent_activity_controller.dart';
import '../../../gen/assets.gen.dart';

class RecentActivityView extends StatelessWidget {
  RecentActivityView({super.key});

  RecentActivityController recentActivityController = Get.put(RecentActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildRecentActivityList(),
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
            Get.back();
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        AppString.recentActivity,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildRecentActivityList() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.today,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: AppSize.appSize16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentActivityController.todayActivityList.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentActivityController.todayActivityList[index],
                    style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                  ),
                  Divider(
                    color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
                    thickness: AppSize.appSizePoint7,
                    height: AppSize.appSize0,
                  ).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize26),
                ],
              );
            },
          ),
          Text(
            AppString.yesterday,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(top: AppSize.appSize10),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: AppSize.appSize16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentActivityController.yesterdayActivityList.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentActivityController.yesterdayActivityList[index],
                    style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                  ),
                  Divider(
                    color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
                    thickness: AppSize.appSizePoint7,
                    height: AppSize.appSize0,
                  ).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize26),
                ],
              );
            },
          ),
          Text(
            AppString.december25,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(top: AppSize.appSize10),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: AppSize.appSize16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentActivityController.decemberActivityList.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentActivityController.decemberActivityList[index],
                    style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                  ),
                  Divider(
                    color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
                    thickness: AppSize.appSizePoint7,
                    height: AppSize.appSize0,
                  ).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize26),
                ],
              );
            },
          ),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16, right: AppSize.appSize16,
      ),
    );
  }
}

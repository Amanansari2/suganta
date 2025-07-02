import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/notification_controller.dart';
import '../../gen/assets.gen.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildNotificationsList(),
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
        AppString.notifications,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildNotificationsList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: AppSize.appSize16, right: AppSize.appSize16,
        top: AppSize.appSize10, bottom: AppSize.appSize20,
      ),
      physics: const ClampingScrollPhysics(),
      itemCount: notificationController.notificationTitleList.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notificationController.notificationTitleList[index],
              style: AppStyle.heading5Medium(
                color: index > AppSize.size4
                    ? AppColor.textColor.withOpacity(AppSize.appSizePoint50)
                    : AppColor.textColor,
              ),
            ),
            Text(
              notificationController.notificationSubTitleList[index],
              style: AppStyle.heading5Regular(
                color: index > AppSize.size4
                    ? AppColor.descriptionColor.withOpacity(AppSize.appSizePoint50)
                    : AppColor.descriptionColor,
              ),
            ).paddingOnly(top: AppSize.appSize6),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                notificationController.notificationTimingList[index],
                style: AppStyle.heading6Regular(
                  color: index > AppSize.size4
                      ? AppColor.descriptionColor.withOpacity(AppSize.appSizePoint50)
                      : AppColor.descriptionColor,
                ),
              ).paddingOnly(top: AppSize.appSize6),
            ),
            if(index < notificationController.notificationTitleList.length - AppSize.size1)...[
              Divider(
                color: index > AppSize.size4
                    ? AppColor.descriptionColor.withOpacity(AppSize.appSizePoint2)
                    : AppColor.descriptionColor.withOpacity(AppSize.appSizePoint50),
                thickness: AppSize.appSizePoint7,
                height: AppSize.appSize0,
              ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize16),
            ],
          ],
        );
      },
    );
  }
}

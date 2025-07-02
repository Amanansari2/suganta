import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/interesting_reads_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';

class InterestingReadsView extends StatelessWidget {
  InterestingReadsView({super.key});

  InterestingReadsController interestingReadsController = Get.put(InterestingReadsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildInterestingReadsList(),
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
        AppString.interestingReads,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildInterestingReadsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: AppSize.appSize10,
        left: AppSize.appSize16, right: AppSize.appSize16,
      ),
      itemCount: interestingReadsController.interestingReadsImageList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.interestingReadsDetailsView);
          },
          child: Container(
            padding: const EdgeInsets.all(AppSize.appSize16),
            margin: const EdgeInsets.only(bottom: AppSize.appSize16),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            child: Row(
              children: [
                Image.asset(
                  interestingReadsController.interestingReadsImageList[index],
                  width: AppSize.appSize80,
                ).paddingOnly(right: AppSize.appSize16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interestingReadsController.interestingReadsTitleList[index],
                        maxLines: AppSize.size3,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.heading5Medium(color: AppColor.textColor),
                      ),
                      Text(
                        interestingReadsController.interestingReadsDateList[index],
                        style: AppStyle.heading6Regular(color: AppColor.descriptionColor),
                      ).paddingOnly(top: AppSize.appSize6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/activity_controller.dart';
import '../../controller/home_controller.dart';
import '../home/widget/manage_property_bottom_sheet.dart';

class ActivityView extends StatelessWidget {
  ActivityView({super.key});

  HomeController homeController = Get.find<HomeController>();

  ActivityController activityController = Get.put(ActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      // appBar: buildAppBar(),
      body: buildActivityView(context),
    );
  }

  Widget buildActivityView(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSize.appSize20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Your Listing",
                style: AppStyle.heading1(color: AppColor.textColor),
              ).paddingOnly(top: AppSize.appSize20),
            ),
            GetBuilder<HomeController>(builder: (postHomeController) {
              final propertyList = postHomeController.postPropertyList;
              if (propertyList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: AppSize.appSize26),
                  child: Center(
                    child: Text("No Properties Found"),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: AppSize.appSize26),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: propertyList.length,
                itemBuilder: (context, index) {
                  final property = propertyList[index];
                  AppLogger.log("Feature: ${property.feature}");
                  AppLogger.log("PG Name: ${property.feature?.pgName}");
                  final imageUrl = property.firstImage?.image != null
                      ? "${AppConfigs.mediaUrl}${property.firstImage!.image}?path=properties"
                      : null;
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSize.appSize26),
                    padding: const EdgeInsets.all(AppSize.appSize16),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.black.withOpacity(0.4),
                              blurRadius: 1,
                              spreadRadius: 1)
                        ]),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColor.black.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 1)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: AppSize.appSize90,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/myImg/please_upload_image.png",
                                        width: AppSize.appSize90,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/myImg/please_upload_image.png",
                                    width: AppSize.appSize90,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ).paddingOnly(right: AppSize.appSize16),
                        Expanded(
                          child: SizedBox(
                            height: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "Price :",
                                        style: AppStyle.heading5(
                                            color: AppColor.textColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      property.feature?.rentAmount.toString() ??
                                          "N/A",
                                      style: AppStyle.heading5Medium(
                                          color: AppColor.textColor),
                                    ),
                                  ],
                                ),
                                if (property.feature?.pgName != null &&
                                    property.feature!.pgName!.trim().isNotEmpty)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Name :",
                                          style: AppStyle.heading5(
                                              color: AppColor.textColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: Text(
                                          property.feature?.pgName ?? 'N/A',
                                          style: AppStyle.heading5SemiBold(
                                              color: AppColor.textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "Address :",
                                        style: AppStyle.heading5(
                                            color: AppColor.textColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${property.address.city}"
                                        "${property.address.area.isNotEmpty ? ', ${property.address.area}' : ''}"
                                        "${(property.address.subLocality ?? '').isNotEmpty ? ', ${property.address.subLocality}' : ''}"
                                        "${property.address.pin != 0 ? ' ${property.address.pin}' : ''}",
                                        maxLines: 3,
                                        style: AppStyle.heading5Regular(
                                            color: AppColor.descriptionColor),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    managePropertyBottomSheet(
                                        context, property);
                                  },
                                  child: Text(
                                    AppString.manageProperty,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ).paddingOnly(
          top: AppSize.appSize10,
          left: AppSize.appSize16,
          right: AppSize.appSize16,
        ),
      ),
    );
  }

// AppBar buildAppBar() {
//   return AppBar(
//     backgroundColor: AppColor.whiteColor,
//     scrolledUnderElevation: AppSize.appSize0,
//     leading: Padding(
//       padding: const EdgeInsets.only(left: AppSize.appSize16),
//       child:
//       GestureDetector(
//          onTap: () {
//           if(activityController.deleteShowing.value == true) {
//             activityController.deleteShowing.value = false;
//             activityController.selectListing.value = AppSize.size0;
//           }
//           else {
//             BottomBarController bottomBarController = Get.put(BottomBarController());
//             bottomBarController.pageController.jumpToPage(AppSize.size0);
//           }
//         },
//         child: Image.asset(
//           Assets.images.backArrow.path,
//         ),
//       ),
//     ),
//     leadingWidth: AppSize.appSize40,
//   );
// }
}

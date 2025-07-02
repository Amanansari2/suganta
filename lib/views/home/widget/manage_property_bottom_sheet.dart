import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/post_property_model.dart';
import '../../../routes/app_routes.dart';
import '../your_listing_detail_page.dart';

managePropertyBottomSheet(BuildContext context, PostPropertyData pgItem) {
  showModalBottomSheet(
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
        height: AppSize.appSize385,
        padding: const EdgeInsets.only(
          top: AppSize.appSize26,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.manageProperty,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    Assets.images.close.path,
                    width: AppSize.appSize24,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: AppSize.appSize70,
                  height: AppSize.appSize70,
                  margin: const EdgeInsets.only(right: AppSize.appSize16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.appSize6),
                      border: Border.all(color: AppColor.black)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.appSize6),
                    child: Image.network(
                      pgItem.firstImage?.image != null &&
                              pgItem.firstImage!.image.isNotEmpty
                          ? "${AppConfigs.mediaUrl}${pgItem.firstImage!.image}?path=properties"
                          : '',
                      width: AppSize.appSize70,
                      height: AppSize.appSize70,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: AppSize.appSize70,
                          height: AppSize.appSize70,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/myImg/please_upload_image.png",
                          width: AppSize.appSize70,
                          height: AppSize.appSize70,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        pgItem.feature?.pgName ?? 'N/A',
                        style: AppStyle.heading5SemiBold(
                            color: AppColor.textColor),
                      ),
                      Text(
                        "${pgItem.address.city}"
                        "${pgItem.address.area.isNotEmpty ? ', ${pgItem.address.area}' : ''}"
                        "${(pgItem.address.subLocality ?? '').isNotEmpty ? ', ${pgItem.address.subLocality}' : ''}"
                        "${pgItem.address.pin != 0 ? ', PIN: ${pgItem.address.pin}' : ''}",
                        style: AppStyle.heading5Regular(
                            color: AppColor.descriptionColor),
                      ).paddingOnly(top: AppSize.appSize6),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(top: AppSize.appSize26),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => YourListingDetailPage(property: pgItem));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.preview,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Image.asset(
                        Assets.images.arrowRight.path,
                        width: AppSize.appSize20,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColor.descriptionColor
                      .withOpacity(AppSize.appSizePoint3),
                  height: AppSize.appSize0,
                  thickness: AppSize.appSizePoint7,
                ).paddingOnly(
                    top: AppSize.appSize15, bottom: AppSize.appSize15),
                GestureDetector(
                  // onTap: () {
                  //   Get.toNamed(AppRoutes.postPgPropertyEditDetails,arguments: pgItem);
                  //  // Get.to(()=>  PostPropertyEditDetails(pgItem: pgItem,));
                  // },
                  onTap: () {
                    Get.back(); // close bottom sheet first

                    final residentialIds = [2, 3, 4, 5, 6];
                    final commercialIds = [1, 8, 9, 11];

                    if (pgItem.typeOptionsId == null && pgItem.wantTo == "PG") {
                      Get.toNamed(AppRoutes.postPgPropertyEditDetails,
                          arguments: pgItem);
                    } else if (residentialIds.contains(pgItem.typeOptionsId)) {
                      Get.toNamed(AppRoutes.postResidentialPropertyEditDetails,
                          arguments: pgItem);
                    } else if (commercialIds.contains(pgItem.typeOptionsId)) {
                      Get.toNamed(AppRoutes.postCommercialPropertyEditDetails,
                          arguments: pgItem);
                    } else {
                      Get.snackbar("Error",
                          "Unknown property type, can't open edit screen");
                    }
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.editDetails,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Image.asset(
                        Assets.images.arrowRight.path,
                        width: AppSize.appSize20,
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: AppColor.descriptionColor
                      .withOpacity(AppSize.appSizePoint3),
                  height: AppSize.appSize0,
                  thickness: AppSize.appSizePoint7,
                ).paddingOnly(
                    top: AppSize.appSize15, bottom: AppSize.appSize15),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.postPgPropertyEditImage,
                        arguments: pgItem);
                    // Get.to(()=>  PostPropertyEditDetails(pgItem: pgItem,));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.updateUploadImage,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Image.asset(
                        Assets.images.arrowRight.path,
                        width: AppSize.appSize20,
                      ),
                    ],
                  ),
                ),

                // Divider(
                //   color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
                //   height: AppSize.appSize0,
                //   thickness: AppSize.appSizePoint7,
                // ).paddingOnly(top: AppSize.appSize15, bottom: AppSize.appSize15),
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //     Get.toNamed(AppRoutes.deleteListingView);
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         AppString.deleteProperty,
                //         style: AppStyle.heading4Medium(color: AppColor.textColor),
                //       ),
                //       Image.asset(
                //         Assets.images.arrowRight.path,
                //         width: AppSize.appSize20,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ).paddingOnly(top: AppSize.appSize26),
          ],
        ),
      ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom);
    },
  );
}

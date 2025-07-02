import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/app_config.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/project_post_property_model.dart';
import '../../../routes/app_routes.dart';
import '../your_project_listing_detail_page.dart';

manageProjectBottomSheet(BuildContext context, ProjectPostModel projectData) {
  showModalBottomSheet(
      backgroundColor: AppColor.transparent,
      shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSize.appSize12),
              topRight: Radius.circular(AppSize.appSize12)),
          borderSide: BorderSide.none),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: AppSize.appSize385,
          padding: const EdgeInsets.only(
              top: AppSize.appSize26,
              left: AppSize.appSize26,
              right: AppSize.appSize26),
          decoration: const BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.appSize12),
                topRight: Radius.circular(AppSize.appSize12),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.manageProject,
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
                  )
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
                      border: Border.all(color: AppColor.black),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.appSize6),
                      child: (projectData.projectImages.isNotEmpty &&
                              projectData.projectImages.first.images != null &&
                              projectData.projectImages.first.images.isNotEmpty)
                          ? Image.network(
                              "${AppConfigs.mediaUrl}${projectData.projectImages.first.images}?path=project",
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
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
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
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
                            )
                          : Image.asset(
                              "assets/myImg/please_upload_image.png",
                              width: AppSize.appSize70,
                              height: AppSize.appSize70,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        projectData.projectName ?? "N/a",
                        style: AppStyle.heading5SemiBold(
                            color: AppColor.textColor),
                      ),
                      Text(
                        "${projectData.area != null && projectData.area!.isNotEmpty ? '${projectData.area}, ' : ''}${projectData.city ?? ''}-${projectData.zipCode ?? ''}",
                        style: AppStyle.heading5Regular(
                            color: AppColor.descriptionColor),
                      ).paddingOnly(top: AppSize.appSize6),
                    ],
                  ))
                ],
              ).paddingOnly(top: AppSize.appSize26),
              Column(
                children: [
                  // GestureDetector(
                  //   onTap: (){
                  //     Get.back();
                  //    Get.to(()=> YourProjectListingDetailPage(project: projectData));
                  //   },
                  //   child:
                  //
                  //   Container(
                  //     width: double.infinity,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           AppString.preview,
                  //           style: AppStyle.heading4Medium(color: AppColor
                  //               .textColor),
                  //         ),
                  //         Image.asset(
                  //           Assets.images.arrowRight.path,
                  //           width: AppSize.appSize20,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Get.to(() => YourProjectListingDetailPage(
                              project: projectData));
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppString.preview,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Image.asset(
                            Assets.images.arrowRight.path,
                            width: AppSize.appSize20,
                          ),
                        ],
                      ),
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
                      Get.back();
                      Get.toNamed(AppRoutes.postProjectEditDetails,
                          arguments: projectData);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.editDetails,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor),
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
                      Get.toNamed(AppRoutes.postProjectEditImage,
                          arguments: projectData);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.updateUploadImage,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor),
                        ),
                        Image.asset(
                          Assets.images.arrowRight.path,
                          width: AppSize.appSize20,
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(top: AppSize.appSize26)
            ],
          ),
        ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom);
      });
}

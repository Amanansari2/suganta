import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api_service/app_config.dart';
import '../../common/price_format_utils.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/home_controller.dart';
import '../../controller/project_details_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/project_post_property_model.dart';
import '../../routes/app_routes.dart';

class YourProjectListingDetailPage extends StatelessWidget {
  final dynamic project;

  YourProjectListingDetailPage({super.key, required this.project});

  final HomeController homeController = Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

  final ProjectDetailsController projectDetailsController =
      Get.isRegistered<ProjectDetailsController>()
          ? Get.find<ProjectDetailsController>()
          : Get.put(ProjectDetailsController());

  @override
  Widget build(BuildContext context) {
    return
        // Obx(() =>

        Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildProjectDetails(context, project),
    );
    // body: buildPropertyDetails(context),

    // ));
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      title: Text(
        "Detail Page",
        style: AppStyle.heading3SemiBold(color: AppColor.black),
      ),
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

      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(AppSize.appSize40),
      //   child: SizedBox(
      //     height: AppSize.appSize40,
      //     child: ListView(
      //       scrollDirection: Axis.horizontal,
      //       children: [
      //         Row(
      //           children: List.generate(homeController.propertyList.length, (index) {
      //             return GestureDetector(
      //               onTap: () {
      //                 // homeController.updateProperty(index);
      //               },
      //               child: Obx(() => Container(
      //                 height: AppSize.appSize25,
      //                 padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize14),
      //                 decoration: BoxDecoration(
      //                   border: Border(
      //                     bottom: BorderSide(
      //                       color: homeController.selectProperty.value == index
      //                           ? AppColor.primaryColor
      //                           : AppColor.borderColor,
      //                       width: AppSize.appSize1,
      //                     ),
      //                     right: BorderSide(
      //                       color: index == AppSize.size6
      //                           ? Colors.transparent
      //                           : AppColor.borderColor,
      //                       width: AppSize.appSize1,
      //                     ),
      //                   ),
      //                 ),
      //                 child: Center(
      //                   child: Text(
      //                     homeController.propertyList[index],
      //                     style: AppStyle.heading5Medium(
      //                       color: homeController.selectProperty.value == index
      //                           ? AppColor.primaryColor
      //                           : AppColor.textColor,
      //                     ),
      //                   ),
      //                 ),
      //               )),
      //             );
      //           }),
      //         ).paddingOnly(
      //           top: AppSize.appSize10,
      //           left: AppSize.appSize16, right: AppSize.appSize16,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget buildProjectDetails(BuildContext context, ProjectPostModel project) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize30),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppSize.appSize200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  ),
                  Image.network(
                    project.projectImages.isNotEmpty
                        ? "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project"
                        : "",
                    fit: BoxFit.fill,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: AppColor.primaryColor,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/myImg/no_preview_available.png",
                        width: double.infinity,
                        fit: BoxFit.fill,
                      );
                    },
                  )
                ],
              ),
            ),
          ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
          Text(
            (() {
              final cleaned =
                  project.priceRange.replaceAll(RegExp(r'\s*to\s*'), '-');
              final parts = cleaned.split('-');
              if (parts.length == 2) {
                final min = num.tryParse(parts[0].trim());
                final max = num.tryParse(parts[1].trim());
                if (min != null && max != null) {
                  return "${PriceFormatUtils.formatIndianAmount(min, withRupee: false)} - ${PriceFormatUtils.formatIndianAmount(max, withRupee: false)}";
                }
              }
              final single = num.tryParse(cleaned.trim());
              return single != null
                  ? PriceFormatUtils.formatIndianAmount(single,
                      withRupee: false)
                  : cleaned;
            })(),
            style: AppStyle.heading2(color: AppColor.primaryColor),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            "Location",
            style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize8,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            "${project.area != null ? "${project.area}," : ""} ${project.city} -${project.zipCode}, ${project.country}",
            style: AppStyle.heading4Regular(color: AppColor.black),
          ).paddingOnly(
            top: AppSize.appSize4,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Highlights",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize8,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(AppSize.appSize20),
                    boxShadow: [
                      BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 1,
                          spreadRadius: 2,
                          offset: const Offset(0, 2))
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Project Type : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          project.project.toString() == '1'
                              ? 'Commercial'
                              : 'Residential',
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Possession Date : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          DateFormat('dd MMM yyyy').format(
                              DateTime.parse(project.createdAt).toLocal()),
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize10),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rera Number : ",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                        Text(
                          project.reraRegister ?? "N/A",
                          style:
                              AppStyle.heading4SemiBold(color: AppColor.black),
                        ).paddingOnly(right: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize10),
                    const Divider(
                      thickness: 1,
                      color: AppColor.descriptionColor,
                    ),
                  ],
                ).paddingAll(AppSize.appSize20),
              ).paddingAll(
                AppSize.appSize20,
              )
            ],
          ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Status",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize8,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              buildProjectStatusGrid(project),
            ],
          ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Financial Details",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize16,
              ),
              buildProjectBigStatus(
                  label: "Payment Schedule",
                  value: PriceFormatUtils.formatIndianAmount(
                      num.tryParse(project.paymentSchedule ?? "0") ?? 0)),
              buildProjectBigStatus(
                  label: "Property Tax (Annual)",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.propertyTaxAnnual ?? 0)),
              buildProjectBigStatus(
                  label: "Maintenance Fees",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.maintenanceFees ?? 0)),
              buildProjectBigStatus(
                  label: "Additional Fees",
                  value: PriceFormatUtils.formatIndianAmount(
                      num.tryParse(project.additionalFees ?? "0") ?? 0)),
              buildProjectBigStatus(
                  label: "Occupancy Rate",
                  value:
                      "${PriceFormatUtils.formatIndianAmount(project.accupancyRate ?? 0, withRupee: false)} %"),
              buildProjectBigStatus(
                  label: "Annual Rental Income",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.annualRentalIncome ?? 0)),
              buildProjectBigStatus(
                  label: "Current Valuation",
                  value: PriceFormatUtils.formatIndianAmount(
                      project.currentValuation ?? 0)),
            ],
          ).paddingOnly(left: AppSize.appSize20, right: AppSize.appSize30),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Amenities",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                  top: AppSize.appSize8,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  bottom: AppSize.appSize16),
              Obx(() {
                final labels = projectDetailsController
                    .getAmenitiesLabelByKey(project.amenities);
                if (projectDetailsController.isAmenitiesLoading.value) {
                  return const CircularProgressIndicator();
                }
                if (labels.isEmpty) {
                  return Text(
                    "No Amenities Available",
                    style: AppStyle.heading3(color: AppColor.primaryColor),
                  );
                }
                return Wrap(
                  runSpacing: 10,
                  children: projectDetailsController
                      .getAmenitiesLabelByKey(project.amenities)
                      .map((label) => Container(
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    offset: const Offset(0, 2),
                                    blurRadius: 1,
                                    spreadRadius: 1),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(
                              label,
                              style: AppStyle.heading3(color: Colors.white),
                            ),
                          ).paddingOnly(
                              left: AppSize.appSize10,
                              right: AppSize.appSize10))
                      .toList(),
                );
              }),
            ],
          ),
          if (project.projectImages.isNotEmpty)
            const Divider(
              thickness: 1,
              color: AppColor.descriptionColor,
            ).paddingOnly(
              top: AppSize.appSize20,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
          if (project.projectImages.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.projectMediaGallery,
                  style: AppStyle.heading2(color: AppColor.textColor),
                ).paddingOnly(
                    top: AppSize.appSize8,
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                    bottom: AppSize.appSize16),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.galleryView, arguments: {
                      "images": project.projectImages
                          .map((img) =>
                              "${AppConfigs.mediaUrl}${img.images}?path=project")
                          .toList(),
                    });
                  },
                  child: Container(
                    height: AppSize.appSize285,
                    margin: const EdgeInsets.only(top: AppSize.appSize16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          project.projectImages.isNotEmpty
                              ? Image.network(
                                  "${AppConfigs.mediaUrl}${project.projectImages.first.images}?path=project",
                                  width: double.infinity,
                                  height: AppSize.appSize285,
                                  fit: BoxFit.fill,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                        color: AppColor.primaryColor,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/myImg/no_preview_available.png",
                                      height: AppSize.appSize285,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ).paddingOnly(
                      left: AppSize.appSize16, right: AppSize.appSize16),
                ),
                project.projectImages.isNotEmpty
                    ? Row(
                        children: [
                          if (project.projectImages.length > 1)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.galleryView, arguments: {
                                  "images": project.projectImages
                                      .map((img) =>
                                          "${AppConfigs.mediaUrl}${img.images}?path=project")
                                      .toList(),
                                });
                              },
                              child: Container(
                                height: AppSize.appSize150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.appSize12),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.appSize12),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      Image.network(
                                        "${AppConfigs.mediaUrl}${project.projectImages[1].images}?path=project",
                                        width: double.infinity,
                                        height: AppSize.appSize285,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                              color: AppColor.primaryColor,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            "assets/myImg/no_preview_available.png",
                                            height: AppSize.appSize285,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          const SizedBox(
                            width: AppSize.appSize16,
                          ),
                          if (project.projectImages.length > 2)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.galleryView, arguments: {
                                  "images": project.projectImages
                                      .map((img) =>
                                          "${AppConfigs.mediaUrl}${img.images}?path=project")
                                      .toList(),
                                });
                              },
                              child: Container(
                                height: AppSize.appSize150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.appSize12),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.appSize12),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      Image.network(
                                        "${AppConfigs.mediaUrl}${project.projectImages[2].images}?path=project",
                                        width: double.infinity,
                                        height: AppSize.appSize285,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                              color: AppColor.primaryColor,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            "assets/myImg/no_preview_available.png",
                                            height: AppSize.appSize285,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        ],
                      ).paddingOnly(
                        top: AppSize.appSize16,
                        left: AppSize.appSize16,
                        right: AppSize.appSize16,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          const Divider(
            thickness: 1,
            color: AppColor.descriptionColor,
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Description :",
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(
                  top: AppSize.appSize8,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  bottom: AppSize.appSize16),
              Text(
                project.projectDescription ?? "N/A",
                style: AppStyle.heading5Medium(color: AppColor.black),
              ).paddingOnly(right: AppSize.appSize16, left: AppSize.appSize16),
            ],
          )
        ],
      ),
    );
  }

  Widget buildProjectStatusGrid(ProjectPostModel project) {
    final items = [
      buildProjectStatus(
          label: "Total Towers", value: project.totalTowers?.toString()),
      buildProjectStatus(
          label: "Total Floors", value: project.totalFloors?.toString()),
      buildProjectStatus(
          label: "BedRooms", value: project.noOfBedroom?.toString()),
      buildProjectStatus(label: "BHK", value: project.noOfBhk?.toString()),
      buildProjectStatus(
          label: "BathRooms", value: project.noOfBathroom?.toString()),
      buildProjectStatus(
          label: "Balconies", value: project.noOfBalcony?.toString()),
      buildProjectStatus(label: "Lift", value: project.lift?.toString()),
      buildProjectStatus(
          label: "Parking Space", value: project.parkingSpace?.toString()),
      buildProjectStatus(label: "Facing", value: project.facing?.toString()),
    ];
    final visibleItems = items.where((item) => item is! SizedBox).toList();
    if (visibleItems.length.isOdd) visibleItems.add(const SizedBox.shrink());

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSize.appSize10,
      crossAxisSpacing: AppSize.appSize20,
      childAspectRatio: 2.8,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize16),
      children: visibleItems,
    );
  }

  Widget buildProjectStatus({
    required String label,
    required String? value,
    bool hideIfEmpty = true,
    String? suffix,
  }) {
    final shouldHide = hideIfEmpty &&
        (value == null || value.trim().isEmpty || value.trim() == '0');
    if (shouldHide) return const SizedBox.shrink();

    final double itemWidth = (Get.width / 2) - AppSize.appSize40;

    return Container(
      width: itemWidth,
      padding: const EdgeInsets.only(
          top: AppSize.appSize15,
          bottom: AppSize.appSize15,
          left: AppSize.appSize10,
          right: AppSize.appSize15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppColor.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2)),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label :",
            style: AppStyle.heading4SemiBold(color: AppColor.black),
          ).paddingOnly(right: AppSize.appSize10),
          Flexible(
            child: Text(
              suffix != null ? "$value $suffix" : value!,
              overflow: TextOverflow.ellipsis,
              // maxLines: 1,
              style: AppStyle.heading4SemiBold(color: AppColor.black),
            ),
          ),
        ],
      ),
    ).paddingOnly(top: AppSize.appSize16);
  }

  Widget buildProjectBigStatus({
    required String label,
    required String? value,
    bool hideIfEmpty = true,
    String? suffix,
  }) {
    final shouldHide = hideIfEmpty &&
        (value == null || value.trim().isEmpty || value.trim() == '0');
    if (shouldHide) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.only(
          top: AppSize.appSize15,
          bottom: AppSize.appSize15,
          left: AppSize.appSize10,
          right: AppSize.appSize15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppColor.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2)),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label : ",
            style: AppStyle.heading4SemiBold(color: AppColor.black),
          ).paddingOnly(right: AppSize.appSize10),
          Text(
            suffix != null ? "$value $suffix" : value!,
            overflow: TextOverflow.ellipsis,
            // maxLines: 1,
            style: AppStyle.heading4SemiBold(color: AppColor.black),
          ),
        ],
      ),
    ).paddingOnly(top: AppSize.appSize16);
  }
}

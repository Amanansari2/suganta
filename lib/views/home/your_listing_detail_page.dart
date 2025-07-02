import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_service/app_config.dart';
import '../../common/common_rich_text.dart';
import '../../common/price_format_utils.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/home_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/text_segment_model.dart';
import '../../routes/app_routes.dart';

class YourListingDetailPage extends StatelessWidget {
  final dynamic property;

  final RxBool showNavigateButton = false.obs;

  YourListingDetailPage({super.key, required this.property});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return
        // Obx(() =>

        Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildPropertyDetails(context),
    );

    // );
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
      // actions: [
      //    Row(
      //     children: [
      //     //   GestureDetector(
      //     //     onTap: () {
      //     //       Get.toNamed(AppRoutes.searchView);
      //     //     },
      //     //     child: Image.asset(
      //     //       Assets.images.search.path,
      //     //       width: AppSize.appSize24,
      //     //       color: AppColor.descriptionColor,
      //     //     ).paddingOnly(right: AppSize.appSize26),
      //     //   ),
      //       // GestureDetector(
      //       //   onTap: () {
      //       //     Get.back();
      //       //     Get.back();
      //       //     Get.back();
      //       //     Future.delayed(const Duration(milliseconds: AppSize.size400), () {
      //       //       BottomBarController bottomBarController = Get.put(BottomBarController());
      //       //       bottomBarController.pageController.jumpToPage(AppSize.size3);
      //       //     },);
      //       //   },
      //       //   child: Image.asset(
      //       //     Assets.images.save.path,
      //       //     width: AppSize.appSize24,
      //       //     color: AppColor.descriptionColor,
      //       //   ).paddingOnly(right: AppSize.appSize26),
      //       // ),
      //       // GestureDetector(
      //       //   onTap: () {
      //       //     final String propertySlug = property.slug ?? property.id.toString();
      //       //     AppLogger.log("Share Slug Print-->>>> $propertySlug");
      //       //     final String shareUrl = "${AppConfigs.shareUrl}$propertySlug";
      //       //     AppLogger.log("Share Slug Print-->>>> $shareUrl");
      //       //
      //       //     Share.share("Check out this property: $shareUrl");
      //       //   },
      //       //   child: Image.asset(
      //       //     Assets.images.share.path,
      //       //     width: AppSize.appSize24,
      //       //   ),
      //       // ),
      //     ],
      //   ).paddingOnly(right: AppSize.appSize16),
      // ],
    );
  }

  Widget buildPropertyDetails(BuildContext context) {
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
                    if (property.firstImage?.image != null &&
                        property.firstImage!.image!.isNotEmpty)
                      Image.network(
                        //"assets/myImg/no_preview_available.png",
                        "${AppConfigs.mediaUrl}${property.firstImage!.image}?path=properties",
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
                    else
                      Image.asset(
                        "assets/myImg/no_preview_available.png",
                        height: AppSize.appSize285,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                  ],
                ),
              )).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
          Text(
            property.feature.rentAmount != null &&
                    property.feature.rentAmount! > 0
                ? PriceFormatUtils.formatIndianAmount(
                    property.feature.rentAmount ?? 0)
                : PriceFormatUtils.formatIndianAmount(
                    property.feature.pricePerSquareFt ?? 0),
            style: AppStyle.heading4Medium(color: AppColor.primaryColor),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  property.feature?.isUnderConstruction == 0
                      ? "Under Construction"
                      : "Ready to Move",
                  // "Ready to move",
                  style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor),
                ),
                VerticalDivider(
                  color: AppColor.descriptionColor
                      .withOpacity(AppSize.appSizePoint4),
                  thickness: AppSize.appSizePoint7,
                  width: AppSize.appSize22,
                  indent: AppSize.appSize2,
                  endIndent: AppSize.appSize2,
                ),
                Text(
                  "${property.feature?.furnishedType ?? 'N/A'}",
                  style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor),
                ),
              ],
            ),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            "Location",
            style: AppStyle.heading5SemiBold(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize8,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            "${property.address.subLocality != null ? "${property.address.subLocality}," : ""}${property.address.area}, ${property.address.city}",
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ).paddingOnly(
            top: AppSize.appSize4,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
            thickness: AppSize.appSizePoint7,
            height: AppSize.appSize0,
          ).paddingOnly(
            top: AppSize.appSize16,
            bottom: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

//////////////////////////////////////////////////Icons Section-----------

          Row(
            children: [
              if (property.feature.bedrooms != null &&
                  property.feature.bedrooms != 0)
                _buildIconWithTextBox(
                  iconPath: Assets.images.bed.path,
                  label: "Bed Rooms",
                  value: "${property.feature.bedrooms}",
                ),
              if (property.feature.bathrooms != null &&
                  property.feature.bathrooms != 0)
                _buildIconWithTextBox(
                  iconPath: Assets.images.bath.path,
                  label: "Bath Rooms",
                  value: "${property.feature.bathrooms}",
                ),
              if (property.feature.balconies != null &&
                  property.feature.balconies != 0)
                _buildIconWithTextBox(
                  iconPath: "assets/myImg/balcony.png",
                  label: "Balcony",
                  value: "${property.feature.balconies}",
                ),
            ],
          ).paddingOnly(left: AppSize.appSize16),

          Wrap(
            spacing: AppSize.appSize16,
            runSpacing: AppSize.appSize10,
            children: [
              if (property.feature.carpetArea != null &&
                  property.feature.carpetArea != 0)
                _buildAreaBox(
                    "Carpet Area", "${property.feature.carpetArea} sq. ft."),
              if (property.feature.buildArea != null &&
                  property.feature.buildArea != 0)
                _buildAreaBox(
                    "Build Area", "${property.feature.buildArea} sq. ft."),
              if (property.feature.plotArea != null &&
                  property.feature.plotArea != 0)
                _buildAreaBox(
                    "Plot Area", "${property.feature.plotArea} sq. ft."),
            ],
          ).paddingOnly(
              top: AppSize.appSize10,
              left: AppSize.appSize16,
              right: AppSize.appSize16),

//////////////////////////////property Details -------------
          Container(
            margin: const EdgeInsets.only(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              color: AppColor.secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.propertyDetails,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                buildPropertyRow(label: "Listing Type", value: property.wantTo),
                buildPropertyRow(label: "Building Type", value: property.type),
                buildPropertyRow(label: "Property Type", value: ""),
                //property.typeOption?.option ),
                buildPropertyRow(
                    label: "Sub Locality", value: property.address.subLocality),
                buildPropertyRow(label: "Area", value: property.address.area),
                buildPropertyRow(label: "City", value: property.address.city),
                buildPropertyRow(
                    label: "PinCode", value: property.address.pin?.toString()),
                buildPropertyRow(
                    label: "BHK Flats",
                    value: property.feature.bhk?.toString()),
                buildPropertyRow(
                    label: "Furnishing Status",
                    value: property.feature.furnishedType),
                buildPropertyRow(
                    label: "Age Of Property",
                    value: property.feature.ageOfProperty?.toString(),
                    suffix: "Years"),
                buildPropertyRow(
                    label: "Pantry", value: property.feature.pantry),
                buildPropertyRow(
                    label: "Plot Facing",
                    value: property.feature.plotFacingDirection),
              ],
            ).paddingOnly(
              left: AppSize.appSize16,
              right: AppSize.appSize16,
              top: AppSize.appSize16,
              bottom: AppSize.appSize16,
            ),
          ),

          //////////Images ---------

          (property.firstImage?.image != null &&
                  property.firstImage!.image!.isNotEmpty)
              ? Column(
                  children: [
                    Text(
                      AppString.takeATourOfOurProperty,
                      style:
                          AppStyle.heading4SemiBold(color: AppColor.textColor),
                    ).paddingOnly(
                      top: AppSize.appSize36,
                      left: AppSize.appSize16,
                      right: AppSize.appSize16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.galleryView, arguments: {
                          "images": property.images
                              .map((img) =>
                                  "${AppConfigs.mediaUrl}${img.image}?path=properties")
                              .toList(),
                        });
                      },
                      child: Container(
                        height: AppSize.appSize285,
                        margin: const EdgeInsets.only(top: AppSize.appSize16),
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
                              if (property.firstImage?.image != null &&
                                  property.firstImage!.image!.isNotEmpty)
                                Image.network(
                                  // "assets/myImg/no_preview_available.png",
                                  "${AppConfigs.mediaUrl}${property.firstImage!.image}?path=properties",
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
                            ],
                          ),
                        ),
                      ).paddingOnly(
                          left: AppSize.appSize16, right: AppSize.appSize16),
                    ),
                  ],
                )
              : const SizedBox.shrink(),

          property.images.isNotEmpty
              ? Row(
                  children: [
                    if (property.images.length > 1)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.galleryView, arguments: {
                              "images": property.images
                                  .map((img) =>
                                      "${AppConfigs.mediaUrl}${img.image}?path=properties")
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
                              child: Builder(
                                builder: (context) {
                                  final img = (property.images.length > 1)
                                      ? property.images[1].image
                                      : null;

                                  if (img == null || img.isEmpty) {
                                    return Image.asset(
                                      "assets/myImg/no_preview_available.png",
                                      height: AppSize.appSize285,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    );
                                  }

                                  final url =
                                      "${AppConfigs.mediaUrl}$img?path=properties";

                                  return Image.network(
                                    url,
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
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: AppSize.appSize16),
                    if (property.images.length > 2)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.galleryView, arguments: {
                              "images": property.images
                                  .map((img) =>
                                      "${AppConfigs.mediaUrl}${img.image}?path=properties")
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
                              child: Builder(
                                builder: (context) {
                                  final img = (property.images.length > 2)
                                      ? property.images[2].image
                                      : null;

                                  if (img == null || img.isEmpty) {
                                    return Image.asset(
                                      "assets/myImg/no_preview_available.png",
                                      height: AppSize.appSize285,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    );
                                  }

                                  final url =
                                      "${AppConfigs.mediaUrl}$img?path=properties";

                                  return Image.network(
                                    url,
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
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ).paddingOnly(
                  top: AppSize.appSize16,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                )
              : const SizedBox.shrink(),

          Text(
            AppString.aboutProperty,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
              bottom: AppSize.appSize10),

          CommonRichText(
            segments: [
              TextSegment(
                text: property.description ?? "No description available",
                style:
                    AppStyle.heading5Regular(color: AppColor.descriptionColor),
              ),
            ],
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
        ],
      ).paddingOnly(top: AppSize.appSize10),
    );
  }

  Widget _buildIconWithTextBox({
    required String iconPath,
    required String label,
    required String value,
  }) {
    if (value.isEmpty || value == "0") return const SizedBox.shrink();

    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.appSize8,
        horizontal: AppSize.appSize10,
      ),
      margin: const EdgeInsets.only(right: AppSize.appSize12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        border: Border.all(
          color: AppColor.primaryColor,
          width: AppSize.appSizePoint50,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: AppSize.appSize16,
                height: AppSize.appSize16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppStyle.heading6Regular(color: AppColor.textColor),
              ),
            ],
          ),
          const Divider(
            color: AppColor.primaryColor,
            thickness: 0.5,
            height: AppSize.appSize12,
          ),
          Text(
            value,
            style: AppStyle.heading5Medium(color: AppColor.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.appSize6,
        horizontal: AppSize.appSize14,
      ),
      margin: const EdgeInsets.only(right: AppSize.appSize16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        border: Border.all(
          color: AppColor.primaryColor,
          width: AppSize.appSizePoint50,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppStyle.heading5Medium(color: AppColor.textColor),
          ),
          Text(
            value,
            style: AppStyle.heading5Medium(color: AppColor.textColor),
          ),
        ],
      ),
    );
  }

  Widget buildPropertyRow({
    required String label,
    required String? value,
    bool hideIfEmpty = true,
    bool isNumber = false,
    String? suffix,
  }) {
    final shouldHide = hideIfEmpty &&
        (value == null || value.trim().isEmpty || value.trim() == "0");

    if (shouldHide) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                label,
                style:
                    AppStyle.heading5Regular(color: AppColor.descriptionColor),
              ).paddingOnly(right: AppSize.appSize10),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                suffix != null ? "$value $suffix" : value!,
                style: AppStyle.heading5Regular(color: AppColor.textColor),
              ),
            ),
          ],
        ).paddingOnly(top: AppSize.appSize16),
        Divider(
          color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
          thickness: AppSize.appSizePoint7,
          height: AppSize.appSize0,
        ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize16),
      ],
    );
  }
}

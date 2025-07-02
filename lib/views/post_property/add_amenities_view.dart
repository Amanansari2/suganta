import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tytil_realty/views/post_property/post_property_success_view.dart';

import '../../common/common_button.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/add_amenities_controller.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';

class AddAmenitiesView extends StatelessWidget {
  AddAmenitiesView({super.key});

  AddAmenitiesController addAmenitiesController =
      Get.put(AddAmenitiesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildAddAmenitiesFields(),
      bottomNavigationBar: buildButton(context),
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
        AppString.addAmenities,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildAddAmenitiesFields() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppString.amenities,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ),
              Text(
                AppString.optional,
                style:
                    AppStyle.heading6Regular(color: AppColor.descriptionColor),
              ),
            ],
          ),
          Wrap(
            runSpacing: AppSize.appSize10,
            spacing: AppSize.appSize16,
            children: List.generate(addAmenitiesController.amenitiesList.length,
                (index) {
              return GestureDetector(
                onTap: () {
                  addAmenitiesController.updateAmenities(index);
                },
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSize.appSize10,
                      horizontal: AppSize.appSize16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                      border: Border.all(
                        color: addAmenitiesController.selectAmenities.value ==
                                index
                            ? AppColor.primaryColor
                            : AppColor.descriptionColor,
                      ),
                    ),
                    child: Text(
                      addAmenitiesController.amenitiesList[index],
                      style: AppStyle.heading5Regular(
                        color: addAmenitiesController.selectAmenities.value ==
                                index
                            ? AppColor.primaryColor
                            : AppColor.descriptionColor,
                      ),
                    ),
                  );
                }),
              );
            }),
          ).paddingOnly(top: AppSize.appSize16),
          Row(
            children: [
              Text(
                AppString.amenities,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ),
              Text(
                AppString.optional,
                style:
                    AppStyle.heading6Regular(color: AppColor.descriptionColor),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize36),
          Wrap(
            runSpacing: AppSize.appSize10,
            spacing: AppSize.appSize16,
            children: List.generate(
                addAmenitiesController.waterSourceList.length, (index) {
              return GestureDetector(
                onTap: () {
                  addAmenitiesController.updateWaterSource(index);
                },
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSize.appSize10,
                      horizontal: AppSize.appSize16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                      border: Border.all(
                        color: addAmenitiesController.selectWaterSource.value ==
                                index
                            ? AppColor.primaryColor
                            : AppColor.descriptionColor,
                      ),
                    ),
                    child: Text(
                      addAmenitiesController.waterSourceList[index],
                      style: AppStyle.heading5Regular(
                        color: addAmenitiesController.selectWaterSource.value ==
                                index
                            ? AppColor.primaryColor
                            : AppColor.descriptionColor,
                      ),
                    ),
                  );
                }),
              );
            }),
          ).paddingOnly(top: AppSize.appSize16),
          Row(
            children: [
              Text(
                AppString.otherFeature,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ),
              Text(
                AppString.optional,
                style:
                    AppStyle.heading6Regular(color: AppColor.descriptionColor),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize36),
          Column(
            children: List.generate(
                addAmenitiesController.otherFeaturesList.length, (index) {
              return GestureDetector(
                onTap: () {
                  addAmenitiesController.updateOtherFeatures(index);
                },
                child: Row(
                  children: [
                    Obx(() => Image.asset(
                          addAmenitiesController.selectOtherFeatures.value ==
                                  index
                              ? Assets.images.checkbox.path
                              : Assets.images.emptyCheckbox.path,
                          width: AppSize.appSize20,
                        )).paddingOnly(right: AppSize.appSize6),
                    Text(
                      addAmenitiesController.otherFeaturesList[index],
                      style:
                          AppStyle.heading6Regular(color: AppColor.textColor),
                    ),
                  ],
                ).paddingOnly(bottom: AppSize.appSize10),
              );
            }),
          ).paddingOnly(top: AppSize.appSize16),
          Row(
            children: [
              Text(
                AppString.locationAdvantages,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ),
              Text(
                AppString.optional,
                style:
                    AppStyle.heading6Regular(color: AppColor.descriptionColor),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize36),
          Wrap(
            runSpacing: AppSize.appSize10,
            spacing: AppSize.appSize16,
            children: List.generate(
                addAmenitiesController.locationAdvantagesList.length, (index) {
              return GestureDetector(
                onTap: () {
                  addAmenitiesController.updateLocationAdvantages(index);
                },
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSize.appSize10,
                      horizontal: AppSize.appSize16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                      border: Border.all(
                        color: addAmenitiesController
                                    .selectLocationAdvantages.value ==
                                index
                            ? AppColor.primaryColor
                            : AppColor.descriptionColor,
                      ),
                    ),
                    child: Text(
                      addAmenitiesController.locationAdvantagesList[index],
                      style: AppStyle.heading5Regular(
                        color: addAmenitiesController
                                    .selectLocationAdvantages.value ==
                                index
                            ? AppColor.primaryColor
                            : AppColor.descriptionColor,
                      ),
                    ),
                  );
                }),
              );
            }),
          ).paddingOnly(top: AppSize.appSize16),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => postPropertySuccessDialogue(),
          );
          Future.delayed(const Duration(seconds: AppSize.size4), () {
            Get.back();
            Get.offAllNamed(AppRoutes.showPropertyDetailsView);
          });
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          AppString.postPropertyButton,
          style: AppStyle.heading5Medium(color: AppColor.whiteColor),
        ),
      ).paddingOnly(
        left: AppSize.appSize16,
        right: AppSize.appSize16,
        bottom: AppSize.appSize26,
        top: AppSize.appSize10,
      ),
    );
  }
}

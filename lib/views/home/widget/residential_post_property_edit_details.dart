import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../api_service/print_logger.dart';
import '../../../common/common_button.dart';
import '../../../common/common_textfield.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/residential_post_edit_property_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/city_model.dart';
import '../../../model/post_property_model.dart';
import '../../../routes/app_routes.dart';

class PostResidentialPropertyEditDetails extends StatelessWidget {
  final ResidentialPostEditPropertyController
      residentialPostEditPropertyController =
      Get.find<ResidentialPostEditPropertyController>();

  PostResidentialPropertyEditDetails({super.key}) {
    residentialPostEditPropertyController.residentialCurrentStep.value = 1;

    final PostPropertyData? residentialItem = Get.arguments;
    if (residentialItem != null) {
      residentialPostEditPropertyController
          .setEditResidentialData(residentialItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildResidentialStepWiseForm(context).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
      ),
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
        "Edit Property Details",
        style: AppStyle.heading3Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildResidentialStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (
          residentialPostEditPropertyController.residentialCurrentStep.value) {
        case 1:
          return buildResidentialSection(context);

        case 2:
          return buildResidentialSectionStep2(context);

        case 3:
          return buildResidentialSectionStep3(context);

        case 4:
          return buildResidentialSectionStep4(context);

        default:
          return buildResidentialSection(context);
      }
    });
  }

  ///=============================

  Widget buildResidentialSection(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSize.appSize20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.type,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() {
                  return Wrap(
                    spacing: 5,
                    runSpacing: 1,
                    children: residentialPostEditPropertyController
                        .residentialTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = residentialPostEditPropertyController
                              .residentialTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          residentialPostEditPropertyController
                              .updateSelectedResidentialTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: residentialPostEditPropertyController
                                  .selectedResidentialTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  residentialPostEditPropertyController
                                      .updateSelectedResidentialTypeCategory(
                                          displayValue);
                                }
                              },
                            ),
                            Text(
                              displayValue,
                              style: AppStyle.heading5Regular(
                                color: AppColor.textColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.subType,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() {
                  return Wrap(
                    spacing: 5,
                    runSpacing: 1,
                    children: residentialPostEditPropertyController
                        .residentialSubTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = residentialPostEditPropertyController
                              .residentialSubTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          residentialPostEditPropertyController
                              .updateSelectedResidentialSubTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: residentialPostEditPropertyController
                                  .selectedResidentialSubTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  residentialPostEditPropertyController
                                      .updateSelectedResidentialSubTypeCategory(
                                          displayValue);
                                }
                              },
                            ),
                            Text(
                              displayValue,
                              style: AppStyle.heading5Regular(
                                color: AppColor.textColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ).paddingOnly(top: AppSize.appSize15),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("DETAILS"),
                child: Text(
                  AppString.propertyDetails,
                  style: AppStyle.heading2(color: AppColor.textColor),
                ).paddingOnly(
                    top: AppSize.appSize25, bottom: AppSize.appSize10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Visibility(
                    visible: residentialPostEditPropertyController
                        .shouldShowField("BHK"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.bhk,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller:
                                    residentialPostEditPropertyController
                                        .residentialBhkController,
                                focusNode: residentialPostEditPropertyController
                                    .residentialBhkFocusNode,
                                hasFocus: residentialPostEditPropertyController
                                    .hasResidentialBhkFocus.value,
                                hasInput: residentialPostEditPropertyController
                                    .hasResidentialBhkInput.value,
                                hintText: AppString.enterBhk,
                                labelText: AppString.enterBhk,
                              )).paddingOnly(top: AppSize.appSize10),
                        ],
                      ).paddingOnly(top: AppSize.appSize10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSize.appSize40,
                ),
                Obx(
                  () => Visibility(
                    visible: residentialPostEditPropertyController
                        .shouldShowField("Bedrooms"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfBedroomsText,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller:
                                    residentialPostEditPropertyController
                                        .residentialBedRoomsController,
                                focusNode: residentialPostEditPropertyController
                                    .residentialBedRoomsFocusNode,
                                hasFocus: residentialPostEditPropertyController
                                    .hasResidentialBedRoomsFocus.value,
                                hasInput: residentialPostEditPropertyController
                                    .hasResidentialBedRoomsInput.value,
                                hintText: AppString.addBedrooms,
                                labelText: AppString.addBedrooms,
                              )).paddingOnly(top: AppSize.appSize10),
                        ],
                      ).paddingOnly(top: AppSize.appSize10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Visibility(
                    visible: residentialPostEditPropertyController
                        .shouldShowField("Bathrooms"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfBathrooms,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller:
                                    residentialPostEditPropertyController
                                        .residentialBathroomsController,
                                focusNode: residentialPostEditPropertyController
                                    .residentialBathroomsFocusNode,
                                hasFocus: residentialPostEditPropertyController
                                    .hasResidentialBathroomsFocus.value,
                                hasInput: residentialPostEditPropertyController
                                    .hasResidentialBathroomsInput.value,
                                hintText: AppString.addBathrooms,
                                labelText: AppString.addBathrooms,
                              )).paddingOnly(top: AppSize.appSize10),
                        ],
                      ).paddingOnly(top: AppSize.appSize10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSize.appSize40,
                ),
                Obx(
                  () => Visibility(
                    visible: residentialPostEditPropertyController
                        .shouldShowField("Balconies"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfBalconies,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller:
                                    residentialPostEditPropertyController
                                        .residentialBalconiesController,
                                focusNode: residentialPostEditPropertyController
                                    .residentialBalconiesFocusNode,
                                hasFocus: residentialPostEditPropertyController
                                    .hasResidentialBalconiesFocus.value,
                                hasInput: residentialPostEditPropertyController
                                    .hasResidentialBalconiesInput.value,
                                hintText: AppString.addBalconies,
                                labelText: AppString.addBalconies,
                              )).paddingOnly(top: AppSize.appSize10),
                        ],
                      ).paddingOnly(top: AppSize.appSize10),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("CarpetArea"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.carpetAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostEditPropertyController
                              .residentialCarpetAreaController,
                          focusNode: residentialPostEditPropertyController
                              .residentialCarpetAreaFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialCarpetAreaFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialCarpetAreaInput.value,
                          hintText: AppString.addCarpetArea,
                          labelText: AppString.addCarpetArea,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("PlotArea"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.plotAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostEditPropertyController
                              .residentialPlotAreaController,
                          focusNode: residentialPostEditPropertyController
                              .residentialPlotAreaFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialPlotAreaFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialPlotAreaInput.value,
                          hintText: AppString.addPlotArea,
                          labelText: AppString.addPlotArea,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("BuildUpArea"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.buildupAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostEditPropertyController
                              .residentialBuildUpAreaController,
                          focusNode: residentialPostEditPropertyController
                              .residentialBuildUpAreaFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialBuildUpAreaFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialBuildUpAreaInput.value,
                          hintText: AppString.addBuildupArea,
                          labelText: AppString.addBuildupArea,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("TotalFloors"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.totalFloors,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      // print("Selected Total Floor: ${residentialPostPropertyController.selectedTotalFloor.value}");
                      //  print("Available Floor Options: ${residentialPostPropertyController.totalFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: residentialPostEditPropertyController
                                  .totalFloorOptions.keys
                                  .contains(
                                      residentialPostEditPropertyController
                                          .selectedTotalFloor.value)
                              ? residentialPostEditPropertyController
                                  .selectedTotalFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Total Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: residentialPostEditPropertyController
                              .totalFloorOptions.keys
                              .map((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(key,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              residentialPostEditPropertyController
                                  .updateSelectedTotalFloor(newValue);
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("PropertyFloors"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyFloors,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      AppLogger.log(
                          "Selected Property Floor: ${residentialPostEditPropertyController.selectedPropertyFloor.value}");
                      AppLogger.log(
                          "Available Property Floor: ${residentialPostEditPropertyController.propertyFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: residentialPostEditPropertyController
                                  .propertyFloorOptions.keys
                                  .contains(
                                      residentialPostEditPropertyController
                                          .selectedPropertyFloor.value)
                              ? residentialPostEditPropertyController
                                  .selectedPropertyFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Property Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: residentialPostEditPropertyController
                              .propertyFloorOptions.keys
                              .map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              residentialPostEditPropertyController
                                  .updateSelectedPropertyFloor(newValue);
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("AgeOfProperty"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.ageOfProperty,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostEditPropertyController
                              .residentialAgeOfPropertyController,
                          focusNode: residentialPostEditPropertyController
                              .residentialAgeOfPropertyFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialAgeOfPropertyFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialAgeOfPropertyInput.value,
                          hintText: AppString.addPropertyAge,
                          labelText: AppString.addPropertyAge,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("Availability"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.availability,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: residentialPostEditPropertyController
                            .residentialAvailabilityCategories.keys
                            .map((displayValue) {
                          String apiValue =
                              residentialPostEditPropertyController
                                          .residentialAvailabilityCategories[
                                      displayValue] ??
                                  "";
                          return GestureDetector(
                            onTap: () {
                              residentialPostEditPropertyController
                                  .updateSelectedResidentialAvailabilityCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      residentialPostEditPropertyController
                                          .selectedResidentialAvailabilityCategory
                                          .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      residentialPostEditPropertyController
                                          .updateSelectedResidentialAvailabilityCategory(
                                              displayValue);
                                    }
                                  },
                                ),
                                Text(
                                  displayValue,
                                  style: AppStyle.heading5Regular(
                                    color: AppColor.textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("FurnishedStatus"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.furnishedTypeStatus,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: residentialPostEditPropertyController
                            .residentialFurnishedTypeStatusCategories.keys
                            .map((displayValue) {
                          String apiValue = residentialPostEditPropertyController
                                      .residentialFurnishedTypeStatusCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              residentialPostEditPropertyController
                                  .updateSelectedResidentialFurnishedTypeStatusCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: residentialPostEditPropertyController
                                      .selectedResidentialFurnishedTypeStatusCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      residentialPostEditPropertyController
                                          .updateSelectedResidentialFurnishedTypeStatusCategory(
                                              displayValue);
                                    }
                                  },
                                ),
                                Text(
                                  displayValue,
                                  style: AppStyle.heading5Regular(
                                    color: AppColor.textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("ParkingStatus"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.parkingStatus,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: residentialPostEditPropertyController
                            .residentialParkingStatusCategories.keys
                            .map((displayValue) {
                          String apiValue =
                              residentialPostEditPropertyController
                                          .residentialParkingStatusCategories[
                                      displayValue] ??
                                  "";
                          return GestureDetector(
                            onTap: () {
                              residentialPostEditPropertyController
                                  .updateSelectedResidentialParkingStatusCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: residentialPostEditPropertyController
                                      .selectedResidentialParkingStatusCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      residentialPostEditPropertyController
                                          .updateSelectedResidentialParkingStatusCategory(
                                              displayValue);
                                    }
                                  },
                                ),
                                Text(
                                  displayValue,
                                  style: AppStyle.heading5Regular(
                                    color: AppColor.textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("PropertyLength"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyLengthInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostEditPropertyController
                              .residentialPropertyLengthController,
                          focusNode: residentialPostEditPropertyController
                              .residentialPropertyLengthFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialPropertyLengthFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialPropertyLengthInput.value,
                          hintText: AppString.addPropertyLength,
                          labelText: AppString.addPropertyLength,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("PropertyBreadth"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyBreadth,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostEditPropertyController
                              .residentialPropertyBreadthController,
                          focusNode: residentialPostEditPropertyController
                              .residentialPropertyBreadthFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialPropertyBreadthFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialPropertyBreadthInput.value,
                          hintText: AppString.addPropertyBreadth,
                          labelText: AppString.addPropertyBreadth,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              ),
            ),
            Obx(() {
              return Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("PlotLandType"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyBreadth,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Wrap(
                      spacing: 5,
                      runSpacing: 1,
                      children: residentialPostEditPropertyController
                          .residentialPlotLandTypeCategories.keys
                          .map((displayValue) {
                        String apiValue = residentialPostEditPropertyController
                                    .residentialPlotLandTypeCategories[
                                displayValue] ??
                            "";
                        return GestureDetector(
                          onTap: () {
                            residentialPostEditPropertyController
                                .updateSelectedResidentialPlotLandTypeCategory(
                                    displayValue);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: apiValue,
                                groupValue:
                                    residentialPostEditPropertyController
                                        .selectedResidentialPlotLandTypeCategory
                                        .value,
                                activeColor: AppColor.primaryColor,
                                onChanged: (value) {
                                  if (value != null) {
                                    residentialPostEditPropertyController
                                        .updateSelectedResidentialPlotLandTypeCategory(
                                            displayValue);
                                  }
                                },
                              ),
                              Text(
                                displayValue,
                                style: AppStyle.heading5Regular(
                                  color: AppColor.textColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ).paddingOnly(top: AppSize.appSize15),
              );
            }),
            Obx(
              () => Visibility(
                visible: residentialPostEditPropertyController
                    .shouldShowField("Next"),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Obx(() {
                    return residentialPostEditPropertyController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          )
                        : CommonButton(
                            onPressed: () async {
                              await residentialPostEditPropertyController
                                  .submitEditResidentialDetailsStep1();
                              if (residentialPostEditPropertyController
                                  .isResidentialDetailSubmitted) {
                                residentialPostEditPropertyController
                                    .residentialCurrentStep.value = 2;
                              }
                            },
                            backgroundColor: AppColor.primaryColor,
                            child: Text(
                              AppString.nextButton,
                              style: AppStyle.heading5Medium(
                                  color: AppColor.whiteColor),
                            ),
                          ).paddingOnly(
                            left: AppSize.appSize16,
                            right: AppSize.appSize16,
                            bottom: AppSize.appSize26,
                            top: AppSize.appSize10,
                          );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildResidentialSectionStep2(BuildContext context) {
    return GetBuilder<ResidentialPostEditPropertyController>(
        builder: (residentialPostEditPropertyController2) {
      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSize.appSize20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CITY DROPDOWN ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.city,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColor.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TypeAheadField<City>(
                      controller: TextEditingController(
                          text: residentialPostEditPropertyController2
                                  .selectedResidentialCity?.name ??
                              ""),
                      builder: (context, textEditingController, focusNode) {
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: "Type to search city...",
                            hintStyle:
                                TextStyle(color: AppColor.descriptionColor),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                          ),
                        );
                      },
                      suggestionsCallback: (String pattern) async {
                        return residentialPostEditPropertyController2
                            .residentialCityOptions
                            .where((city) => city.name
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, City suggestion) {
                        return ListTile(
                          title: Text(suggestion.name),
                        );
                      },
                      onSelected: (City selectedCity) {
                        residentialPostEditPropertyController2
                            .selectedResidentialCity = selectedCity;
                        residentialPostEditPropertyController2
                            .citySearchController.text = selectedCity.name;
                        residentialPostEditPropertyController2.update();
                      },
                    ),
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.area,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  CommonTextField(
                    controller: residentialPostEditPropertyController2
                        .residentialAreaController,
                    focusNode: residentialPostEditPropertyController2
                        .residentialAreaFocusNode,
                    hasFocus: residentialPostEditPropertyController2
                        .hasResidentialAreaFocus.value,
                    hasInput: residentialPostEditPropertyController2
                        .hasResidentialAreaInput.value,
                    hintText: AppString.enterYourArea,
                    labelText: AppString.enterYourArea,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.subLocality,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  CommonTextField(
                    controller: residentialPostEditPropertyController2
                        .residentialSubLocalityController,
                    focusNode: residentialPostEditPropertyController2
                        .residentialSubLocalityFocusNode,
                    hasFocus: residentialPostEditPropertyController2
                        .hasResidentialSubLocalityFocus.value,
                    hasInput: residentialPostEditPropertyController2
                        .hasResidentialSubLocalityInput.value,
                    hintText: AppString.enterYourSubLocality,
                    labelText: AppString.enterYourSubLocality,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.houseNo,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor))
                      .paddingOnly(top: 10),
                  CommonTextField(
                    controller: residentialPostEditPropertyController2
                        .residentialHouseNoController,
                    focusNode: residentialPostEditPropertyController2
                        .residentialHouseNoFocusNode,
                    hasFocus: residentialPostEditPropertyController2
                        .hasResidentialHouseNoFocus.value,
                    hasInput: residentialPostEditPropertyController2
                        .hasResidentialHouseNoInput.value,
                    hintText: AppString.houseNo,
                    labelText: AppString.houseNo,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.zipCode,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor))
                      .paddingOnly(top: 10),
                  CommonTextField(
                    keyboardType: TextInputType.phone,
                    controller: residentialPostEditPropertyController2
                        .residentialZipCodeController,
                    focusNode: residentialPostEditPropertyController2
                        .residentialZipCodeFocusNode,
                    hasFocus: residentialPostEditPropertyController2
                        .hasResidentialZipCodeFocus.value,
                    hasInput: residentialPostEditPropertyController2
                        .hasResidentialZipCodeInput.value,
                    hintText: AppString.zipCode,
                    labelText: AppString.zipCode,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CommonButton(
                  onPressed: () async {
                    await residentialPostEditPropertyController2
                        .submitResidentialDetailsStep2();
                    if (residentialPostEditPropertyController2
                        .isResidentialDetailSubmittedStep2) {
                      residentialPostEditPropertyController2
                          .residentialCurrentStep.value = 3;
                      residentialPostEditPropertyController2.update();
                    }
                  },
                  backgroundColor: AppColor.primaryColor,
                  child: Text(AppString.nextButton,
                      style:
                          AppStyle.heading5Medium(color: AppColor.whiteColor)),
                ).paddingOnly(
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  bottom: AppSize.appSize26,
                  top: AppSize.appSize20,
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  Widget buildResidentialSectionStep3(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSize.appSize20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.expectedAmount,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.number,
                      controller: residentialPostEditPropertyController
                          .residentialRentAmountController,
                      focusNode: residentialPostEditPropertyController
                          .residentialRentAmountFocusNode,
                      hasFocus: residentialPostEditPropertyController
                          .hasResidentialRentAmountFocus.value,
                      hasInput: residentialPostEditPropertyController
                          .hasResidentialRentAmountInput.value,
                      hintText: AppString.enterAmount,
                      labelText: AppString.enterAmount,
                    )).paddingOnly(
                  top: AppSize.appSize10,
                ),
                Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.pricingOptions,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                            ),
                            CheckboxListTile(
                              title: const Text("All Inclusive Price"),
                              value: residentialPostEditPropertyController
                                  .allInclusivePrice.value,
                              onChanged: (val) {
                                residentialPostEditPropertyController
                                    .allInclusivePrice.value = val!;
                              },
                            ),
                            CheckboxListTile(
                              title:
                                  const Text("Tax and Govt. charges excluded"),
                              value: residentialPostEditPropertyController
                                  .taxAndGovtChargesExcluded.value,
                              onChanged: (val) {
                                residentialPostEditPropertyController
                                    .taxAndGovtChargesExcluded.value = val!;
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Price is Negotiable"),
                              value: residentialPostEditPropertyController
                                  .priceNegotiable.value,
                              onChanged: (val) {
                                residentialPostEditPropertyController
                                    .priceNegotiable.value = val!;
                              },
                            ),
                          ],
                        ))
                    .paddingOnly(
                      top: AppSize.appSize10,
                    )
                    .paddingOnly(
                      top: AppSize.appSize25,
                    ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppString.ownerShip,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ).paddingOnly(
                    top: AppSize.appSize25,
                  ),
                ),
                Obx(() {
                  return Wrap(
                    spacing: 15,
                    runSpacing: 1,
                    children: residentialPostEditPropertyController
                        .residentialOwnerShipCategories.keys
                        .map((displayValue) {
                      String apiValue = residentialPostEditPropertyController
                              .residentialOwnerShipCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          residentialPostEditPropertyController
                              .updateSelectedResidentialOwnerShipCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: residentialPostEditPropertyController
                                  .selectedResidentialOwnerShipCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  residentialPostEditPropertyController
                                      .updateSelectedResidentialOwnerShipCategory(
                                          displayValue);
                                }
                              },
                            ),
                            Text(
                              displayValue,
                              style: AppStyle.heading5Regular(
                                color: AppColor.textColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyUnique,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          controller: residentialPostEditPropertyController
                              .residentialDescribePropertyController,
                          focusNode: residentialPostEditPropertyController
                              .residentialDescribePropertyFocusNode,
                          hasFocus: residentialPostEditPropertyController
                              .hasResidentialDescribePropertyFocus.value,
                          hasInput: residentialPostEditPropertyController
                              .hasResidentialDescribePropertyInput.value,
                          hintText: AppString.describeProperty,
                          labelText: AppString.describeProperty,
                        )).paddingOnly(
                      top: AppSize.appSize10,
                    )
                  ],
                ).paddingOnly(
                  top: AppSize.appSize25,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CommonButton(
                    onPressed: () async {
                      await residentialPostEditPropertyController
                          .submitEditResidentialDetailsStep3();
                      if (residentialPostEditPropertyController
                          .isResidentialDetailSubmittedStep3) {
                        residentialPostEditPropertyController
                            .residentialCurrentStep.value = 4;
                        residentialPostEditPropertyController.update();
                      }
                    },
                    backgroundColor: AppColor.primaryColor,
                    child: Text(
                      AppString.nextButton,
                      style:
                          AppStyle.heading5Medium(color: AppColor.whiteColor),
                    ),
                  ).paddingOnly(
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                    bottom: AppSize.appSize26,
                    top: AppSize.appSize10,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  List<File> selectedImages = [];

  Widget buildResidentialSectionStep4(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      physics: const BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColor.descriptionColor)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upload Images',
                  style: AppStyle.heading3SemiBold(color: AppColor.textColor),
                ).paddingOnly(
                    top: AppSize.appSize10,
                    right: AppSize.appSize10,
                    left: AppSize.appSize10),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.find<HomeController>().fetchPostPropertyList();
                      Get.find<HomeController>().fetchPostProjectListing();
                      Get.offNamed(AppRoutes.bottomBarView);
                    },
                    child: const Text(
                      AppString.skip,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                          fontSize: AppSize.appSize18,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.primaryColor,
                          decorationThickness: 2,
                          decorationStyle: TextDecorationStyle.solid),
                    ),
                  ),
                ).paddingAll(AppSize.appSize10),
              ],
            ),
            Divider(
              thickness: 1,
              color: AppColor.descriptionColor.withOpacity(0.5),
            ).paddingOnly(
                left: AppSize.appSize10,
                right: AppSize.appSize10,
                bottom: AppSize.appSize10),
            Container(
              width: double.infinity,
              height: AppSize.appSize250,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: InkWell(
                onTap: () async {
                  AppLogger.log("Upload clicked");
                  selectedImages = await pickMultipleImages();
                  (context as Element).markNeedsBuild();
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Click to upload.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ).paddingOnly(
                top: AppSize.appSize10,
                bottom: AppSize.appSize10,
                left: AppSize.appSize10,
                right: AppSize.appSize10),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Selected Images :",
                style: AppStyle.heading3Medium(color: AppColor.black),
              ),
            ).paddingAll(AppSize.appSize10),
            if (selectedImages.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(selectedImages.length, (index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImages[index],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            selectedImages.removeAt(index);
                            (context as Element).markNeedsBuild();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ).paddingOnly(left: 10, right: 10, bottom: 10),
            Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: CommonButton(
                        onPressed: () async {
                          await residentialPostEditPropertyController
                              .submitEditStep4UploadImagesResidentialDetails(
                                  selectedImages);
                          if (residentialPostEditPropertyController
                              .isResidentialDetailSubmittedStep4) {
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: residentialPostEditPropertyController
                                .isLoadingStep4.value
                            ? const CupertinoActivityIndicator(
                                radius: 10,
                                color: AppColor.whiteColor,
                              )
                            : Text(
                                AppString.submitButton,
                                style: AppStyle.heading5Medium(
                                    color: AppColor.whiteColor),
                              ),
                      ).paddingOnly(
                        left: AppSize.appSize16,
                        right: AppSize.appSize16,
                        bottom: AppSize.appSize26,
                        top: AppSize.appSize10,
                      ),
                    ))
                .paddingOnly(
                    left: AppSize.appSize10,
                    right: AppSize.appSize10,
                    top: AppSize.appSize10,
                    bottom: AppSize.appSize10),
          ],
        ),
      ),
    );
  }

  Future<List<File>> pickMultipleImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.paths
            .whereType<String>()
            .map((path) => File(path))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.log('Error picking images: $e');
      return [];
    }
  }
}

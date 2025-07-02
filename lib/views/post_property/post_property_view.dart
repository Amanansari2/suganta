import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api_service/print_logger.dart';
import '../../common/common_button.dart';
import '../../common/common_textfield.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/commercial_post_property_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/pg_post_property_controller.dart';
import '../../controller/project_post_property_controller.dart';
import '../../controller/residential_post_property_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/city_model.dart';
import '../../model/project_dropdown_model.dart';
import '../../routes/app_routes.dart';
import 'package:collection/collection.dart';

class PostPropertyView extends StatelessWidget {
  PostPropertyView({super.key});

  ResidentialPostPropertyController residentialPostPropertyController =
      Get.find<ResidentialPostPropertyController>();
  CommercialPostPropertyController commercialPostPropertyController =
      Get.find<CommercialPostPropertyController>();
  PGPostPropertyController pgPostPropertyController =
      Get.find<PGPostPropertyController>();
  ProjectPostPropertyController projectPostPropertyController =
      Get.find<ProjectPostPropertyController>();

  FocusNode pgCityFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body:
          //  buildOldPostProperty(context),
          Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              AppString.lookingTo,
              style: AppStyle.heading4Medium(color: AppColor.textColor),
            ),
          ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
                pgPostPropertyController.propertyLookingList.length, (index) {
              return GetBuilder<PGPostPropertyController>(
                  builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    controller.updatePropertyLooking(index);
                  },
                  child: Container(
                    width: (Get.width - AppSize.appSize48) / 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.appSize16,
                      vertical: AppSize.appSize10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                      color: AppColor.whiteColor,
                      border: Border.all(
                        color: controller.selectPropertyLooking.value == index
                            ? AppColor.primaryColor
                            : AppColor.borderColor,
                        width: AppSize.appSize1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.propertyLookingList[index],
                        style: AppStyle.heading5Medium(
                          color: controller.selectPropertyLooking.value == index
                              ? AppColor.primaryColor
                              : AppColor.descriptionColor,
                        ),
                      ),
                    ),
                  ),
                );
              });
            }),
          ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize16),
          Expanded(
            child: buildPostProperty(context),
          ),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
      ),

      // bottomNavigationBar: buildButton(context),
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
            int selectedTab =
                pgPostPropertyController.selectPropertyLooking.value;

            if (selectedTab == 0) {
              if (residentialPostPropertyController
                      .residentialCurrentStep.value >
                  1) {
                residentialPostPropertyController
                    .residentialCurrentStep.value--;
              } else {
                Get.back();
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (Get.isRegistered<ResidentialPostPropertyController>()) {
                    Get.delete<ResidentialPostPropertyController>();
                  }
                });
              }
            } else if (selectedTab == 1) {
              if (commercialPostPropertyController.commercialCurrentStep.value >
                  1) {
                commercialPostPropertyController.commercialCurrentStep.value--;
              } else {
                Get.back();
                Future.delayed(
                    const Duration(
                      milliseconds: 500,
                    ), () {
                  if (Get.isRegistered<CommercialPostPropertyController>()) {
                    Get.delete<CommercialPostPropertyController>();
                  }
                });
              }
            } else if (selectedTab == 2) {
              if (pgPostPropertyController.currentStep.value > 1) {
                pgPostPropertyController.currentStep.value--;
              } else {
                Get.back();
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (Get.isRegistered<PGPostPropertyController>()) {
                    Get.delete<PGPostPropertyController>();
                  }
                });
              }
            } else if (selectedTab == 3) {
              if (projectPostPropertyController.projectCurrentStep.value > 1) {
                projectPostPropertyController.projectCurrentStep.value--;
              } else {
                Get.back();
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (Get.isRegistered<ProjectPostPropertyController>()) {
                    Get.delete<ProjectPostPropertyController>();
                  }
                });
              }
            } else {
              Get.back();
              Future.delayed(const Duration(milliseconds: 500), () {
                if (Get.isRegistered<ResidentialPostPropertyController>()) {
                  Get.delete<ResidentialPostPropertyController>();
                }
                if (Get.isRegistered<CommercialPostPropertyController>()) {
                  Get.delete<CommercialPostPropertyController>();
                }
                if (Get.isRegistered<PGPostPropertyController>()) {
                  Get.delete<PGPostPropertyController>();
                }
                if (Get.isRegistered<ProjectPostPropertyController>()) {
                  Get.delete<ProjectPostPropertyController>();
                }
              });
            }
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        AppString.postProperty,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildPostProperty(BuildContext context) {
    return GetBuilder<PGPostPropertyController>(builder: (controller) {
      switch (controller.selectPropertyLooking.value) {
        case 0:
          return buildResidentialStepWiseForm(context);

        case 1:
          return buildCommercialStepWiseForm(context);
        case 2:
          return buildPgStepWiseForm(context);

        case 3:
          return buildProjectStepWiseForm(context);

        default:
          return buildResidentialStepWiseForm(context);
      }
    });
  }

  Widget buildResidentialStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (residentialPostPropertyController.residentialCurrentStep.value) {
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

  Widget buildCommercialStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (commercialPostPropertyController.commercialCurrentStep.value) {
        case 1:
          return buildCommercialSection(context);

        case 2:
          return buildCommercialSectionStep2(context);

        case 3:
          return buildCommercialSectionStep3(context);

        case 4:
          return buildCommercialSectionStep4(context);

        default:
          return buildCommercialSection(context);
      }
    });
  }

  Widget buildPgStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (pgPostPropertyController.currentStep.value) {
        case 1:
          return buildPgSection(context);
        case 2:
          return buildPgSectionStep2(context);
        case 3:
          return buildPgSectionStep3(context);
        case 4:
          return buildPgSectionStep4(context);
        default:
          return buildPgSection(context);
      }
    });
  }

  Widget buildProjectStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (projectPostPropertyController.projectCurrentStep.value) {
        case 1:
          return buildProjectSection(context);

        case 2:
          return buildProjectSectionStep2(context);

        case 3:
          return buildProjectSectionStep3(context);

        case 4:
          return buildProjectSectionStep4(context);

        default:
          return buildProjectSection(context);
      }
    });
  }

//////////////////////////////////////////////////////////////////////////////////------------------Residential---------------------------------

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
                RichText(
                  text: TextSpan(
                    text: AppString.type,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return Wrap(
                    spacing: 5,
                    runSpacing: 1,
                    children: residentialPostPropertyController
                        .residentialTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = residentialPostPropertyController
                              .residentialTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          residentialPostPropertyController
                              .updateSelectedResidentialTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: residentialPostPropertyController
                                  .selectedResidentialTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  residentialPostPropertyController
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
                RichText(
                  text: TextSpan(
                    text: AppString.subType,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return Wrap(
                    spacing: 5,
                    runSpacing: 1,
                    children: residentialPostPropertyController
                        .residentialSubTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = residentialPostPropertyController
                              .residentialSubTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          residentialPostPropertyController
                              .updateSelectedResidentialSubTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: residentialPostPropertyController
                                  .selectedResidentialSubTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  residentialPostPropertyController
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
                visible: residentialPostPropertyController
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
                    visible: residentialPostPropertyController
                        .shouldShowField("BHK"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppString.bhk,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                              children: const [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: residentialPostPropertyController
                                    .residentialBhkController,
                                focusNode: residentialPostPropertyController
                                    .residentialBhkFocusNode,
                                hasFocus: residentialPostPropertyController
                                    .hasResidentialBhkFocus.value,
                                hasInput: residentialPostPropertyController
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
                    visible: residentialPostPropertyController
                        .shouldShowField("Bedrooms"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppString.noOfBedroomsText,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                              children: const [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: residentialPostPropertyController
                                    .residentialBedRoomsController,
                                focusNode: residentialPostPropertyController
                                    .residentialBedRoomsFocusNode,
                                hasFocus: residentialPostPropertyController
                                    .hasResidentialBedRoomsFocus.value,
                                hasInput: residentialPostPropertyController
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
                    visible: residentialPostPropertyController
                        .shouldShowField("Bathrooms"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppString.noOfBathrooms,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                              children: const [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: residentialPostPropertyController
                                    .residentialBathroomsController,
                                focusNode: residentialPostPropertyController
                                    .residentialBathroomsFocusNode,
                                hasFocus: residentialPostPropertyController
                                    .hasResidentialBathroomsFocus.value,
                                hasInput: residentialPostPropertyController
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
                    visible: residentialPostPropertyController
                        .shouldShowField("Balconies"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppString.noOfBalconies,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                              children: const [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: residentialPostPropertyController
                                    .residentialBalconiesController,
                                focusNode: residentialPostPropertyController
                                    .residentialBalconiesFocusNode,
                                hasFocus: residentialPostPropertyController
                                    .hasResidentialBalconiesFocus.value,
                                hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("CarpetArea"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.carpetAreaInSqFt,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostPropertyController
                              .residentialCarpetAreaController,
                          focusNode: residentialPostPropertyController
                              .residentialCarpetAreaFocusNode,
                          hasFocus: residentialPostPropertyController
                              .hasResidentialCarpetAreaFocus.value,
                          hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("PlotArea"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.plotAreaInSqFt,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostPropertyController
                              .residentialPlotAreaController,
                          focusNode: residentialPostPropertyController
                              .residentialPlotAreaFocusNode,
                          hasFocus: residentialPostPropertyController
                              .hasResidentialPlotAreaFocus.value,
                          hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("BuildUpArea"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.buildupAreaInSqFt,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostPropertyController
                              .residentialBuildUpAreaController,
                          focusNode: residentialPostPropertyController
                              .residentialBuildUpAreaFocusNode,
                          hasFocus: residentialPostPropertyController
                              .hasResidentialBuildUpAreaFocus.value,
                          hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("TotalFloors"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.totalFloors,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      // debugPrint("Selected Total Floor: ${residentialPostPropertyController.selectedTotalFloor.value}");
                      //  debugPrint("Available Floor Options: ${residentialPostPropertyController.totalFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: residentialPostPropertyController
                                  .totalFloorOptions.keys
                                  .contains(residentialPostPropertyController
                                      .selectedTotalFloor.value)
                              ? residentialPostPropertyController
                                  .selectedTotalFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Total Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: residentialPostPropertyController
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
                              residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("PropertyFloors"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.propertyFloors,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      AppLogger.log(
                          "Selected Property Floor: ${residentialPostPropertyController.selectedPropertyFloor.value}");
                      AppLogger.log(
                          "Available Property Floor: ${residentialPostPropertyController.propertyFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: residentialPostPropertyController
                                  .propertyFloorOptions.keys
                                  .contains(residentialPostPropertyController
                                      .selectedPropertyFloor.value)
                              ? residentialPostPropertyController
                                  .selectedPropertyFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Property Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: residentialPostPropertyController
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
                              residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("AgeOfProperty"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.ageOfProperty,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostPropertyController
                              .residentialAgeOfPropertyController,
                          focusNode: residentialPostPropertyController
                              .residentialAgeOfPropertyFocusNode,
                          hasFocus: residentialPostPropertyController
                              .hasResidentialAgeOfPropertyFocus.value,
                          hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
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
                        children: residentialPostPropertyController
                            .residentialAvailabilityCategories.keys
                            .map((displayValue) {
                          String apiValue = residentialPostPropertyController
                                      .residentialAvailabilityCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              residentialPostPropertyController
                                  .updateSelectedResidentialAvailabilityCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: residentialPostPropertyController
                                      .selectedResidentialAvailabilityCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("FurnishedStatus"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.furnishedTypeStatus,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: residentialPostPropertyController
                            .residentialFurnishedTypeStatusCategories.keys
                            .map((displayValue) {
                          String apiValue = residentialPostPropertyController
                                      .residentialFurnishedTypeStatusCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              residentialPostPropertyController
                                  .updateSelectedResidentialFurnishedTypeStatusCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: residentialPostPropertyController
                                      .selectedResidentialFurnishedTypeStatusCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("ParkingStatus"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.parkingStatus,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: residentialPostPropertyController
                            .residentialParkingStatusCategories.keys
                            .map((displayValue) {
                          String apiValue = residentialPostPropertyController
                                      .residentialParkingStatusCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              residentialPostPropertyController
                                  .updateSelectedResidentialParkingStatusCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: residentialPostPropertyController
                                      .selectedResidentialParkingStatusCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("PropertyLength"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.propertyLengthInSqFt,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostPropertyController
                              .residentialPropertyLengthController,
                          focusNode: residentialPostPropertyController
                              .residentialPropertyLengthFocusNode,
                          hasFocus: residentialPostPropertyController
                              .hasResidentialPropertyLengthFocus.value,
                          hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("PropertyBreadth"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.propertyBreadth,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: residentialPostPropertyController
                              .residentialPropertyBreadthController,
                          focusNode: residentialPostPropertyController
                              .residentialPropertyBreadthFocusNode,
                          hasFocus: residentialPostPropertyController
                              .hasResidentialPropertyBreadthFocus.value,
                          hasInput: residentialPostPropertyController
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
                visible: residentialPostPropertyController
                    .shouldShowField("PlotLandType"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.plotLandTypes,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Wrap(
                      spacing: 5,
                      runSpacing: 1,
                      children: residentialPostPropertyController
                          .residentialPlotLandTypeCategories.keys
                          .map((displayValue) {
                        String apiValue = residentialPostPropertyController
                                    .residentialPlotLandTypeCategories[
                                displayValue] ??
                            "";
                        return GestureDetector(
                          onTap: () {
                            residentialPostPropertyController
                                .updateSelectedResidentialPlotLandTypeCategory(
                                    displayValue);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: apiValue,
                                groupValue: residentialPostPropertyController
                                    .selectedResidentialPlotLandTypeCategory
                                    .value,
                                activeColor: AppColor.primaryColor,
                                onChanged: (value) {
                                  if (value != null) {
                                    residentialPostPropertyController
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
                visible:
                    residentialPostPropertyController.shouldShowField("Next"),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Obx(() {
                    return residentialPostPropertyController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          )
                        : CommonButton(
                            // onPressed: () async {
                            //   await residentialPostPropertyController
                            //       .submitResidentialDetailsStep1();
                            //   if (residentialPostPropertyController
                            //       .isResidentialDetailSubmitted) {
                            //     residentialPostPropertyController
                            //         .residentialCurrentStep.value = 2;
                            //   }
                            // },

                            onPressed: () async {
                              final success =
                                  await residentialPostPropertyController
                                      .submitResidentialDetailsStep1();
                              if (success) {
                                residentialPostPropertyController
                                    .saveResidentialCurrentStep(2);
                                residentialPostPropertyController
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
    return GetBuilder<ResidentialPostPropertyController>(
        builder: (residentialStep2Controller) {
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
                  RichText(
                    text: TextSpan(
                      text: AppString.city,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                      children: const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
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
                          text: residentialStep2Controller
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
                        return residentialStep2Controller.residentialCityOptions
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
                        residentialStep2Controller.selectedResidentialCity =
                            selectedCity;
                        residentialStep2Controller.citySearchController.text =
                            selectedCity.name;
                        residentialStep2Controller.update();
                      },
                    ),
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppString.area,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                      children: const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  CommonTextField(
                    controller:
                        residentialStep2Controller.residentialAreaController,
                    focusNode:
                        residentialStep2Controller.residentialAreaFocusNode,
                    hasFocus: residentialStep2Controller
                        .hasResidentialAreaFocus.value,
                    hasInput: residentialStep2Controller
                        .hasResidentialAreaInput.value,
                    hintText: AppString.enterYourArea,
                    labelText: AppString.enterYourArea,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppString.subLocality,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                      children: const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  CommonTextField(
                    controller: residentialStep2Controller
                        .residentialSubLocalityController,
                    focusNode: residentialStep2Controller
                        .residentialSubLocalityFocusNode,
                    hasFocus: residentialStep2Controller
                        .hasResidentialSubLocalityFocus.value,
                    hasInput: residentialStep2Controller
                        .hasResidentialSubLocalityInput.value,
                    hintText: AppString.enterYourSubLocality,
                    labelText: AppString.enterYourSubLocality,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppString.houseNo,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                      children: const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  CommonTextField(
                    controller:
                        residentialStep2Controller.residentialHouseNoController,
                    focusNode:
                        residentialStep2Controller.residentialHouseNoFocusNode,
                    hasFocus: residentialStep2Controller
                        .hasResidentialHouseNoFocus.value,
                    hasInput: residentialStep2Controller
                        .hasResidentialHouseNoInput.value,
                    hintText: AppString.houseNo,
                    labelText: AppString.houseNo,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppString.zipCode,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                      children: const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  CommonTextField(
                    keyboardType: TextInputType.phone,
                    controller:
                        residentialStep2Controller.residentialZipCodeController,
                    focusNode:
                        residentialStep2Controller.residentialZipCodeFocusNode,
                    hasFocus: residentialStep2Controller
                        .hasResidentialZipCodeFocus.value,
                    hasInput: residentialStep2Controller
                        .hasResidentialZipCodeInput.value,
                    hintText: AppString.zipCode,
                    labelText: AppString.zipCode,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              // --- NEXT BUTTON ---
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CommonButton(
                  onPressed: () async {
                    await residentialStep2Controller
                        .submitResidentialDetailsStep2();
                    if (residentialStep2Controller
                        .isResidentialDetailSubmittedStep2) {
                      residentialStep2Controller.residentialCurrentStep.value =
                          3;
                      residentialStep2Controller.update();
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
                  top: AppSize.appSize10,
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
                      controller: residentialPostPropertyController
                          .residentialRentAmountController,
                      focusNode: residentialPostPropertyController
                          .residentialRentAmountFocusNode,
                      hasFocus: residentialPostPropertyController
                          .hasResidentialRentAmountFocus.value,
                      hasInput: residentialPostPropertyController
                          .hasResidentialRentAmountInput.value,
                      hintText: AppString.enterAmount,
                      labelText: AppString.enterAmount,
                    )).paddingOnly(
                  top: AppSize.appSize10,
                )
              ],
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
                          value: residentialPostPropertyController
                              .allInclusivePrice.value,
                          onChanged: (val) {
                            residentialPostPropertyController
                                .allInclusivePrice.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Tax and Govt. charges excluded"),
                          value: residentialPostPropertyController
                              .taxAndGovtChargesExcluded.value,
                          onChanged: (val) {
                            residentialPostPropertyController
                                .taxAndGovtChargesExcluded.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Price is Negotiable"),
                          value: residentialPostPropertyController
                              .priceNegotiable.value,
                          onChanged: (val) {
                            residentialPostPropertyController
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
                children: residentialPostPropertyController
                    .residentialOwnerShipCategories.keys
                    .map((displayValue) {
                  String apiValue = residentialPostPropertyController
                          .residentialOwnerShipCategories[displayValue] ??
                      "";
                  return GestureDetector(
                    onTap: () {
                      residentialPostPropertyController
                          .updateSelectedResidentialOwnerShipCategory(
                              displayValue);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: apiValue,
                          groupValue: residentialPostPropertyController
                              .selectedResidentialOwnerShipCategory.value,
                          activeColor: AppColor.primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              residentialPostPropertyController
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
                      controller: residentialPostPropertyController
                          .residentialDescribePropertyController,
                      focusNode: residentialPostPropertyController
                          .residentialDescribePropertyFocusNode,
                      hasFocus: residentialPostPropertyController
                          .hasResidentialDescribePropertyFocus.value,
                      hasInput: residentialPostPropertyController
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
                  await residentialPostPropertyController
                      .submitResidentialDetailsStep3();
                  if (residentialPostPropertyController
                      .isResidentialDetailSubmittedStep3) {
                    residentialPostPropertyController
                        .saveResidentialCurrentStep(4);
                    residentialPostPropertyController
                        .residentialCurrentStep.value = 4;
                    residentialPostPropertyController.update();
                  }
                },
                backgroundColor: AppColor.primaryColor,
                child: Text(
                  AppString.nextButton,
                  style: AppStyle.heading5Medium(color: AppColor.whiteColor),
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
      );
    });
  }

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
                      residentialPostPropertyController.storage
                          .remove("res_id");
                      residentialPostPropertyController.storage
                          .remove("residential_property_id");
                      AppLogger.log(
                          "🧹 res_id and residential_property_id removed from GetStorage");
                      residentialPostPropertyController
                          .residentialResetStepProgress();
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
                          await residentialPostPropertyController
                              .submitResidentialDetailsStep4Images(
                                  selectedImages);
                          if (residentialPostPropertyController
                              .isResidentialDetailSubmittedStep4) {
                            residentialPostPropertyController
                                .residentialResetStepProgress();
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: residentialPostPropertyController
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

//////////////////////////////////////////////////////////////////////////////////------------------Commercial---------------------------------

  Widget facilityRadioField({
    required String title,
    required RxString selectedValue,
    required Map<String, String> options,
    required void Function(String displayValue) onChanged,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ),
          Row(
            children: options.entries.map((entry) {
              return Row(
                children: [
                  Radio<String>(
                    value: entry.value,
                    groupValue: selectedValue.value,
                    onChanged: (val) => onChanged(entry.key),
                    activeColor: AppColor.primaryColor,
                  ),
                  Text(entry.key),
                  const SizedBox(width: 40),
                ],
              );
            }).toList(),
          ).paddingOnly(top: AppSize.appSize5),
        ],
      );
    });
  }

  Widget buildCommercialSection(BuildContext context) {
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
                    children: commercialPostPropertyController
                        .commercialTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = commercialPostPropertyController
                              .commercialTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          commercialPostPropertyController
                              .updateSelectedCommercialTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: commercialPostPropertyController
                                  .selectedCommercialTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  commercialPostPropertyController
                                      .updateSelectedCommercialTypeCategory(
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
                    children: commercialPostPropertyController
                        .commercialSubTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = commercialPostPropertyController
                              .commercialSubTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          commercialPostPropertyController
                              .updateSelectedCommercialSubTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: commercialPostPropertyController
                                  .selectedCommercialSubTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  commercialPostPropertyController
                                      .updateSelectedCommercialSubTypeCategory(
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
                visible:
                    commercialPostPropertyController.shouldShowField("DETAILS"),
                child: Text(
                  AppString.commercialDetails,
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
                    visible: commercialPostPropertyController
                        .shouldShowField("SEAT"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfSeats,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: commercialPostPropertyController
                                    .commercialSeatController,
                                focusNode: commercialPostPropertyController
                                    .commercialSeatFocusNode,
                                hasFocus: commercialPostPropertyController
                                    .hasCommercialSeatFocus.value,
                                hasInput: commercialPostPropertyController
                                    .hasCommercialSeatInput.value,
                                hintText: AppString.addSeats,
                                labelText: AppString.addSeats,
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
                    visible: commercialPostPropertyController
                        .shouldShowField("CABIN"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfCabin,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: commercialPostPropertyController
                                    .commercialCabinController,
                                focusNode: commercialPostPropertyController
                                    .commercialCabinFocusNode,
                                hasFocus: commercialPostPropertyController
                                    .hasCommercialCabinFocus.value,
                                hasInput: commercialPostPropertyController
                                    .hasCommercialCabinInput.value,
                                hintText: AppString.addCabins,
                                labelText: AppString.addCabins,
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
                    visible: commercialPostPropertyController
                        .shouldShowField("MEETING"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfMeetingRooms,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: commercialPostPropertyController
                                    .commercialMeetingRoomController,
                                focusNode: commercialPostPropertyController
                                    .commercialMeetingRoomFocusNode,
                                hasFocus: commercialPostPropertyController
                                    .hasCommercialMeetingRoomFocus.value,
                                hasInput: commercialPostPropertyController
                                    .hasCommercialMeetingRoomInput.value,
                                hintText: AppString.addMeetingRooms,
                                labelText: AppString.addMeetingRooms,
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
                    visible: commercialPostPropertyController
                        .shouldShowField("CONFERENCE"),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.noOfConferenceRooms,
                            style: AppStyle.heading4Medium(
                                color: AppColor.textColor),
                          ),
                          Obx(() => CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: commercialPostPropertyController
                                    .commercialConferenceRoomController,
                                focusNode: commercialPostPropertyController
                                    .commercialConferenceRoomFocusNode,
                                hasFocus: commercialPostPropertyController
                                    .hasCommercialConferenceRoomFocus.value,
                                hasInput: commercialPostPropertyController
                                    .hasCommercialConferenceRoomInput.value,
                                hintText: AppString.addConferenceRooms,
                                labelText: AppString.addConferenceRooms,
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
                visible: commercialPostPropertyController
                    .shouldShowField("WASHROOM"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.noOfWashrooms,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialWashroomController,
                          focusNode: commercialPostPropertyController
                              .commercialWashroomFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialWashroomFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialWashroomInput.value,
                          hintText: AppString.addWashrooms,
                          labelText: AppString.addWashrooms,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("RECEPTION"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.receptionArea,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialReceptionAreaCategories.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                      .commercialReceptionAreaCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialReceptionAreaCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialReceptionAreaCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialReceptionAreaCategory(
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("TYPEOFSPACES"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.typeOfSpaces,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialTypeOfSpace.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialTypeOfSpace[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialTypeOfSpace(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialTypeOfSpace.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialTypeOfSpace(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected Type Of Spaces via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("SHOPLOCATEDINSIDE"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.shopLocatedInside,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialShopLocatedInside.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialShopLocatedInside[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialShopLocatedInside(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialShopLocatedInside
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialShopLocatedInside(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected SHOP Located Inside via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("PLOTLANDTYPE"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.typeOfPlotLand,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialTypeOfPlotLand.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialTypeOfPlotLand[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialTypeOfPlotLand(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialTypeOfPlotLand.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialTypeOfPlotLand(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected Type Of Plot/Land via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("TYPEOFSTORAGE"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.typeOfStorage,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialTypeOfStorage.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialTypeOfStorage[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialTypeOfStorage(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialTypeOfStorage.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialTypeOfStorage(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected Type Of Storage via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("PLOTAREA"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.plotAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialPlotAreaController,
                          focusNode: commercialPostPropertyController
                              .commercialPlotAreaFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialPlotAreaFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialPlotAreaInput.value,
                          hintText: AppString.addPlotArea,
                          labelText: AppString.addPlotArea,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    commercialPostPropertyController.shouldShowField("BUILDUP"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.buildupAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialBuildUpAreaController,
                          focusNode: commercialPostPropertyController
                              .commercialBuildUpAreaFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialBuildUpAreaFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialBuildUpAreaInput.value,
                          hintText: AppString.addBuildupArea,
                          labelText: AppString.addBuildupArea,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    commercialPostPropertyController.shouldShowField("CARPET"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.carpetAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialCarpetAreaController,
                          focusNode: commercialPostPropertyController
                              .commercialCarpetAreaFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialCarpetAreaFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialCarpetAreaInput.value,
                          hintText: AppString.addCarpetArea,
                          labelText: AppString.addCarpetArea,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("WIDTHOFFACINGROAD"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.widthOfFacingRoadFeet,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialWidthOfFacingRoadController,
                          focusNode: commercialPostPropertyController
                              .commercialWidthOfFacingRoadFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialWidthOfFacingRoadFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialWidthOfFacingRoadInput.value,
                          hintText: AppString.addWidthInFeet,
                          labelText: AppString.addWidthInFeet,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("PLOTFACING"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.plotFacing,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialPlotFacing.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialPlotFacing[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialPlotFacing(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialPlotFacing.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialPlotFacing(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected Plot Facing via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("TOTALFLOOR"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.totalFloors,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                      //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: commercialPostPropertyController
                                  .totalFloorOptions.keys
                                  .contains(commercialPostPropertyController
                                      .selectedTotalFloor.value)
                              ? commercialPostPropertyController
                                  .selectedTotalFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Total Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: commercialPostPropertyController
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
                              commercialPostPropertyController
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
                visible: commercialPostPropertyController
                    .shouldShowField("PROPERTYFLOOR"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyFloors,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      // debugPrint("Selected Property Floor: ${commercialPostPropertyController.selectedPropertyFloor.value}");
                      //debugPrint("Available Property Floor: ${commercialPostPropertyController.propertyFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: commercialPostPropertyController
                                  .propertyFloorOptions.keys
                                  .contains(commercialPostPropertyController
                                      .selectedPropertyFloor.value)
                              ? commercialPostPropertyController
                                  .selectedPropertyFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Property Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: commercialPostPropertyController
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
                              commercialPostPropertyController
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
                visible: commercialPostPropertyController
                    .shouldShowField("FACILITY"),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: AppColor.black)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColor.primaryColor,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black, // border color
                              width: 1, // border thickness
                            ),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Facilities",
                              style:
                                  AppStyle.heading2(color: AppColor.whiteColor),
                            ).paddingOnly(
                                top: AppSize.appSize10,
                                bottom: AppSize.appSize10)),
                      ),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Furnishing",
                            selectedValue:
                                commercialPostPropertyController.furnishing,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            // onChanged: (val) => commercialPostPropertyController.updateFacility(commercialPostPropertyController.furnishing, val)
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.furnishing,
                                val,
                              );
                              AppLogger.log(
                                  "Furnishing selected value: ${commercialPostPropertyController.furnishing.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Central Ac",
                            selectedValue:
                                commercialPostPropertyController.centralAC,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.centralAC,
                                val,
                              );
                              AppLogger.log(
                                  "Central AC selected value: ${commercialPostPropertyController.centralAC.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Oxygen Duct",
                            selectedValue:
                                commercialPostPropertyController.oxygenDuct,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.oxygenDuct,
                                val,
                              );
                              AppLogger.log(
                                  "OxyGen Duct selected value: ${commercialPostPropertyController.oxygenDuct.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "UPS",
                            selectedValue: commercialPostPropertyController.ups,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.ups,
                                val,
                              );
                              AppLogger.log(
                                  "UPS selected value: ${commercialPostPropertyController.ups.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                    ],
                  ),
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("FIRESAFETY"),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: AppColor.black)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColor.primaryColor,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black, // border color
                              width: 1, // border thickness
                            ),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Fire Safety",
                              style:
                                  AppStyle.heading2(color: AppColor.whiteColor),
                            ).paddingOnly(
                                top: AppSize.appSize10,
                                bottom: AppSize.appSize10)),
                      ),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Fire Extension",
                            selectedValue:
                                commercialPostPropertyController.fireExtension,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            // onChanged: (val) => commercialPostPropertyController.updateFacility(commercialPostPropertyController.furnishing, val)
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.fireExtension,
                                val,
                              );
                              AppLogger.log(
                                  "fireExtension value: ${commercialPostPropertyController.fireExtension.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Fire Sprinklers",
                            selectedValue:
                                commercialPostPropertyController.fireSprinklers,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.fireSprinklers,
                                val,
                              );
                              AppLogger.log(
                                  "fireSprinklers selected value: ${commercialPostPropertyController.fireSprinklers.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Fire Sensors",
                            selectedValue:
                                commercialPostPropertyController.fireSensors,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.fireSensors,
                                val,
                              );
                              AppLogger.log(
                                  "fireSensors selected value: ${commercialPostPropertyController.fireSensors.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "FIre Hose",
                            selectedValue:
                                commercialPostPropertyController.fireHose,
                            options: commercialPostPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostPropertyController.updateFacility(
                                commercialPostPropertyController.fireHose,
                                val,
                              );
                              AppLogger.log(
                                  "fireHose selected value: ${commercialPostPropertyController.fireHose.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                    ],
                  ),
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("AVAILABILITY"),
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
                        children: commercialPostPropertyController
                            .commercialAvailability.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialAvailability[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialAvailability(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialAvailability.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialAvailability(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected Availability via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    commercialPostPropertyController.shouldShowField("PARKING"),
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
                        children: commercialPostPropertyController
                            .commercialParkingStatus.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                  .commercialParkingStatus[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialParkingStatus(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialParkingStatus.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialParkingStatus(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected PARKING via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(() {
              final subtypeKey = commercialPostPropertyController
                      .commercialSubTypeCategories.entries
                      .firstWhereOrNull((entry) =>
                          entry.value ==
                          commercialPostPropertyController
                              .selectedCommercialSubTypeCategory.value)
                      ?.key ??
                  "";

              final label = subtypeKey == "Office"
                  ? AppString.pantryType
                  : AppString.washroomType;

              return Visibility(
                visible:
                    commercialPostPropertyController.shouldShowField("PANTRY"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: commercialPostPropertyController
                            .commercialPantryTypeCategories.keys
                            .map((displayValue) {
                          String apiValue = commercialPostPropertyController
                                      .commercialPantryTypeCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostPropertyController
                                  .updateSelectedCommercialPantryTypeCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostPropertyController
                                      .selectedCommercialPantryTypeCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostPropertyController
                                          .updateSelectedCommercialPantryTypeCategory(
                                              displayValue);
                                      AppLogger.log(
                                          "Selected Pantry via Radio: $displayValue → $apiValue");
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
                ).paddingOnly(top: AppSize.appSize25),
              );
            }),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("STAIRCASE"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.noOfStairCase,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialStairCaseController,
                          focusNode: commercialPostPropertyController
                              .commercialStairCaseFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialStairCaseFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialStairCaseInput.value,
                          hintText: AppString.addStairCase,
                          labelText: AppString.addStairCase,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    commercialPostPropertyController.shouldShowField("LIFT"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.noOflift,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialLiftController,
                          focusNode: commercialPostPropertyController
                              .commercialLiftFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialLiftFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialLiftInput.value,
                          hintText: AppString.addLift,
                          labelText: AppString.addLift,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible: commercialPostPropertyController
                    .shouldShowField("AGEOFPROPERTY"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.ageOfProperty,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostPropertyController
                              .commercialAgeOfPropertyController,
                          focusNode: commercialPostPropertyController
                              .commercialAgeOfPropertyFocusNode,
                          hasFocus: commercialPostPropertyController
                              .hasCommercialAgeOfPropertyFocus.value,
                          hasInput: commercialPostPropertyController
                              .hasCommercialAgeOfPropertyInput.value,
                          hintText: AppString.addPropertyAge,
                          labelText: AppString.addPropertyAge,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize10),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    commercialPostPropertyController.shouldShowField("Next"),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CommonButton(
                    onPressed: () async {
                      await commercialPostPropertyController
                          .submitCommercialDetailStep1();
                      if (commercialPostPropertyController
                          .isCommercialDetailSubmitted) {
                        commercialPostPropertyController
                            .commercialCurrentStep.value = 2;
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
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildCommercialSectionStep2(BuildContext context) {
    return GetBuilder<CommercialPostPropertyController>(
        builder: (commercialPostPropertyControllerStep2) {
      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSize.appSize20),
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                          text: commercialPostPropertyControllerStep2
                                  .selectedCommercialCity?.name ??
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
                        return commercialPostPropertyControllerStep2
                            .commercialCityOptions
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
                        commercialPostPropertyControllerStep2
                            .selectedCommercialCity = selectedCity;
                        commercialPostPropertyControllerStep2
                            .citySearchController.text = selectedCity.name;
                        commercialPostPropertyControllerStep2.update();
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
                    controller: commercialPostPropertyControllerStep2
                        .commercialAreaController,
                    focusNode: commercialPostPropertyControllerStep2
                        .commercialAreaFocusNode,
                    hasFocus: commercialPostPropertyControllerStep2
                        .hasCommercialAreaFocus.value,
                    hasInput: commercialPostPropertyControllerStep2
                        .hasCommercialAreaInput.value,
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
                    controller: commercialPostPropertyControllerStep2
                        .commercialSubLocalityController,
                    focusNode: commercialPostPropertyControllerStep2
                        .commercialSubLocalityFocusNode,
                    hasFocus: commercialPostPropertyControllerStep2
                        .hasCommercialSubLocalityFocus.value,
                    hasInput: commercialPostPropertyControllerStep2
                        .hasCommercialSubLocalityInput.value,
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
                    controller: commercialPostPropertyControllerStep2
                        .commercialHouseNoController,
                    focusNode: commercialPostPropertyControllerStep2
                        .commercialHouseNoFocusNode,
                    hasFocus: commercialPostPropertyControllerStep2
                        .hasCommercialHouseNoFocus.value,
                    hasInput: commercialPostPropertyControllerStep2
                        .hasCommercialHouseNoInput.value,
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
                    controller: commercialPostPropertyControllerStep2
                        .commercialZipCodeController,
                    focusNode: commercialPostPropertyControllerStep2
                        .commercialZipCodeFocusNode,
                    hasFocus: commercialPostPropertyControllerStep2
                        .hasCommercialZipCodeFocus.value,
                    hasInput: commercialPostPropertyControllerStep2
                        .hasCommercialZipCodeInput.value,
                    hintText: AppString.zipCode,
                    labelText: AppString.zipCode,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              // --- NEXT BUTTON ---
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CommonButton(
                  onPressed: () async {
                    await commercialPostPropertyControllerStep2
                        .submitCommercialDetailsStep2();
                    if (commercialPostPropertyControllerStep2
                        .isCommercialDetailSubmittedStep2) {
                      commercialPostPropertyControllerStep2
                          .commercialCurrentStep.value = 3;
                      commercialPostPropertyControllerStep2.update();
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
                  top: AppSize.appSize10,
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  Widget buildCommercialSectionStep3(BuildContext context) {
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
                      controller: commercialPostPropertyController
                          .commercialRentAmountController,
                      focusNode: commercialPostPropertyController
                          .commercialRentAmountFocusNode,
                      hasFocus: commercialPostPropertyController
                          .hasCommercialRentAmountFocus.value,
                      hasInput: commercialPostPropertyController
                          .hasCommercialRentAmountInput.value,
                      hintText: AppString.enterAmount,
                      labelText: AppString.enterAmount,
                    )).paddingOnly(
                  top: AppSize.appSize10,
                )
              ],
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
                          value: commercialPostPropertyController
                              .allInclusivePrice.value,
                          onChanged: (val) {
                            commercialPostPropertyController
                                .allInclusivePrice.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Tax and Govt. charges excluded"),
                          value: commercialPostPropertyController
                              .taxAndGovtChargesExcluded.value,
                          onChanged: (val) {
                            commercialPostPropertyController
                                .taxAndGovtChargesExcluded.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Price is Negotiable"),
                          value: commercialPostPropertyController
                              .priceNegotiable.value,
                          onChanged: (val) {
                            commercialPostPropertyController
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
                children: commercialPostPropertyController
                    .commercialOwnerShipCategories.keys
                    .map((displayValue) {
                  String apiValue = commercialPostPropertyController
                          .commercialOwnerShipCategories[displayValue] ??
                      "";
                  return GestureDetector(
                    onTap: () {
                      commercialPostPropertyController
                          .updateSelectedCommercialOwnerShipCategory(
                              displayValue);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: apiValue,
                          groupValue: commercialPostPropertyController
                              .selectedCommercialOwnerShipCategory.value,
                          activeColor: AppColor.primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              commercialPostPropertyController
                                  .updateSelectedCommercialOwnerShipCategory(
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
                      controller: commercialPostPropertyController
                          .commercialDescribePropertyController,
                      focusNode: commercialPostPropertyController
                          .commercialDescribePropertyFocusNode,
                      hasFocus: commercialPostPropertyController
                          .hasCommercialDescribePropertyFocus.value,
                      hasInput: commercialPostPropertyController
                          .hasCommercialDescribePropertyInput.value,
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
                  await commercialPostPropertyController
                      .submitCommercialDetailsStep3();
                  if (commercialPostPropertyController
                      .isCommercialDetailSubmittedStep3) {
                    commercialPostPropertyController
                        .saveCommercialCurrentStep(4);
                    commercialPostPropertyController
                        .commercialCurrentStep.value = 4;
                    commercialPostPropertyController.update();
                  }
                },
                backgroundColor: AppColor.primaryColor,
                child: Text(
                  AppString.nextButton,
                  style: AppStyle.heading5Medium(color: AppColor.whiteColor),
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
      );
    });
  }

  Widget buildCommercialSectionStep4(BuildContext context) {
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
                      commercialPostPropertyController.storage
                          .remove("commercial_id");
                      commercialPostPropertyController.storage
                          .remove("commercial_property_id");
                      AppLogger.log(
                          "🧹 commercial_id and commercial_property_id removed from GetStorage");
                      commercialPostPropertyController
                          .commercialResetStepProgress();
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
                          await commercialPostPropertyController
                              .submitCommercialDetailsStep4Images(
                                  selectedImages);
                          if (commercialPostPropertyController
                              .isCommercialDetailSubmittedStep4) {
                            commercialPostPropertyController
                                .commercialResetStepProgress();
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: commercialPostPropertyController
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

//////////////////////////////////////////////////////////////////////////////////------------------PG---------------------------------
  Widget buildPgSection(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSize.appSize20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.enterPgName,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() => CommonTextField(
                            controller:
                                pgPostPropertyController.pgNameController,
                            focusNode: pgPostPropertyController.pgNameFocusNode,
                            hasFocus:
                                pgPostPropertyController.hasPgNameFocus.value,
                            hasInput:
                                pgPostPropertyController.hasPgNameInput.value,
                            hintText: AppString.enterPgName,
                            labelText: AppString.enterPgName,
                          )).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.roomType,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: pgPostPropertyController
                                        .selectedPgRoom.value.isNotEmpty ==
                                    true
                                ? pgPostPropertyController.selectedPgRoom.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Room Type",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: pgPostPropertyController.pgRoomOptions
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
                                pgPostPropertyController
                                    .updateSelectedPgRoom(newValue);
                              }
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Date",
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      Obx(() {
                        return GestureDetector(
                          onTap: () =>
                              pgPostPropertyController.selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pgPostPropertyController.selectedDate.value !=
                                          null
                                      ? "${pgPostPropertyController.selectedDate.value!.day}/${pgPostPropertyController.selectedDate.value!.month}/${pgPostPropertyController.selectedDate.value!.year}"
                                      : "Select Date",
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor),
                                ),
                                const Icon(Icons.calendar_today,
                                    color: AppColor.primaryColor),
                              ],
                            ),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.suitableFor,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        return Wrap(
                          spacing: 15,
                          runSpacing: 1,
                          children: pgPostPropertyController.pgCategories.keys
                              .map((displayValue) {
                            String apiValue = pgPostPropertyController
                                    .pgCategories[displayValue] ??
                                "";
                            return GestureDetector(
                              onTap: () {
                                pgPostPropertyController
                                    .updateSelectedPgCategory(displayValue);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: apiValue,
                                    groupValue: pgPostPropertyController
                                        .selectedPgCategory.value,
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (value) {
                                      if (value != null) {
                                        pgPostPropertyController
                                            .updateSelectedPgCategory(
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
                  ).paddingOnly(top: AppSize.appSize25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.houseRule,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      Obx(() {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 1,
                          children: pgPostPropertyController.houseRules.keys
                              .map((rule) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return Checkbox(
                                      value: pgPostPropertyController
                                          .selectedHouseRulesValues
                                          .contains(pgPostPropertyController
                                              .houseRules[rule]),
                                      activeColor: AppColor.primaryColor,
                                      onChanged: (value) {
                                        pgPostPropertyController
                                            .toggleHouseRule(rule);
                                      },
                                    );
                                  }),
                                  Flexible(
                                    child: Text(
                                      rule,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.commonAmenities,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      Obx(() {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 1,
                          children: pgPostPropertyController
                              .commonAmenities.keys
                              .map((amenity) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: pgPostPropertyController
                                        .selectedCommonAmenitiesValues
                                        .contains(pgPostPropertyController
                                            .commonAmenities[amenity]),
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (value) {
                                      pgPostPropertyController
                                          .toggleCommonAmenities(amenity);
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      amenity,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.totalFloors,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        //debugPrint("Selected Total Floor: ${pgPostPropertyController.selectedTotalFloor.value}");
                        // debugPrint("Available Floor Options: ${pgPostPropertyController.totalFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: pgPostPropertyController
                                    .totalFloorOptions.keys
                                    .contains(pgPostPropertyController
                                        .selectedTotalFloor.value)
                                ? pgPostPropertyController
                                    .selectedTotalFloor.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Total Floors",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: pgPostPropertyController
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
                                pgPostPropertyController
                                    .updateSelectedTotalFloor(newValue);
                              }
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.propertyFloors,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        // debugPrint("Selected Property Floor: ${pgPostPropertyController.selectedPropertyFloor.value}");
                        // debugPrint("Available Property Floor: ${pgPostPropertyController.propertyFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: pgPostPropertyController
                                    .propertyFloorOptions.keys
                                    .contains(pgPostPropertyController
                                        .selectedPropertyFloor.value)
                                ? pgPostPropertyController
                                    .selectedPropertyFloor.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Property Floors",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: pgPostPropertyController
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
                                pgPostPropertyController
                                    .updateSelectedPropertyFloor(newValue);
                              }
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Obx(
                      () => pgPostPropertyController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.whiteColor,
                              ),
                            )
                          : CommonButton(
                              onPressed: () async {
                                await pgPostPropertyController
                                    .submitPgDetailsStep1();
                                if (pgPostPropertyController
                                    .isPgDetailSubmitted) {
                                  pgPostPropertyController.currentStep.value =
                                      2;
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
                            ),
                    ),
                  )
                ],
              ),
            ],
          ));
    });
  }

  Widget buildPgSectionStep2(BuildContext context) {
    return GetBuilder<PGPostPropertyController>(
      builder: (controller) {
        AppLogger.log(
            "Selected City: ${pgPostPropertyController.selectedPgCity?.name}");

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSize.appSize20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- CITY DROPDOWN ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.city,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TypeAheadField<City>(
                          controller: TextEditingController(
                              text: controller.selectedPgCity?.name ?? ""),

                          // UI Builder for Input Field
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

                          // Limit the Height of the Suggestions List
                          suggestionsCallback: (String pattern) async {
                            return controller.pgCityOptions
                                .where((city) => city.name
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList();
                          },

                          // Custom Dropdown List
                          itemBuilder: (context, City suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },

                          // On Selection of City
                          onSelected: (City selectedCity) {
                            controller.selectedPgCity = selectedCity;
                            controller.update();
                          },

                          // Wrap the Suggestion Box inside a Constrained Box
                        ),
                      ).paddingOnly(top: 10),
                    ],
                  ).paddingOnly(top: AppSize.appSize10),

                  // --- AREA INPUT ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.area,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor))
                          .paddingOnly(top: 10),
                      CommonTextField(
                        controller: controller.pgAreaController,
                        focusNode: controller.pgAreaFocusNode,
                        hasFocus: controller.hasPgAreaFocus.value,
                        hasInput: controller.hasPgAreaInput.value,
                        hintText: AppString.enterYourArea,
                        labelText: AppString.enterYourArea,
                      ),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),

                  // --- SUB LOCALITY INPUT ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.subLocality,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor))
                          .paddingOnly(top: 10),
                      CommonTextField(
                        controller: controller.pgSubLocalityController,
                        focusNode: controller.pgSubLocalityFocusNode,
                        hasFocus: controller.hasPgSubLocalityFocus.value,
                        hasInput: controller.hasPgSubLocalityInput.value,
                        hintText: AppString.enterYourSubLocality,
                        labelText: AppString.enterYourSubLocality,
                      ),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),

                  // --- HOUSE NO. INPUT ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.houseNo,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor))
                          .paddingOnly(top: 10),
                      CommonTextField(
                        controller: controller.pgHouseNoController,
                        focusNode: controller.pgHouseNoFocusNode,
                        hasFocus: controller.hasPgHouseNoFocus.value,
                        hasInput: controller.hasPgHouseNoInput.value,
                        hintText: AppString.enterYourHouseNo,
                        labelText: AppString.enterYourHouseNo,
                      ),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),

                  // --- ZIP CODE INPUT ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.zipCode,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor))
                          .paddingOnly(top: 10),
                      CommonTextField(
                        keyboardType: TextInputType.number,
                        controller: controller.pgZipCodeController,
                        focusNode: controller.pgZipCodeFocusNode,
                        hasFocus: controller.hasPgZipCodeFocus.value,
                        hasInput: controller.hasPgZipCodeInput.value,
                        hintText: AppString.enterYourZipCOde,
                        labelText: AppString.enterYourZipCOde,
                      ),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),

                  // --- NEXT BUTTON ---
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: CommonButton(
                      onPressed: () async {
                        await controller.submitPgDetailsStep2();
                        if (controller.isPgDetailSubmittedStep2) {
                          controller.currentStep.value = 3;
                          controller.update();
                        }
                      },
                      backgroundColor: AppColor.primaryColor,
                      child: Text(AppString.nextButton,
                          style: AppStyle.heading5Medium(
                              color: AppColor.whiteColor)),
                    ).paddingOnly(
                      left: AppSize.appSize16,
                      right: AppSize.appSize16,
                      bottom: AppSize.appSize26,
                      top: AppSize.appSize10,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildPgSectionStep3(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSize.appSize20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.rentAmount,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.number,
                      controller:
                          pgPostPropertyController.pgRentAmountController,
                      focusNode: pgPostPropertyController.pgRentAmountFocusNode,
                      hasFocus:
                          pgPostPropertyController.hasPgRentAmountFocus.value,
                      hasInput:
                          pgPostPropertyController.hasPgRentAmountInput.value,
                      hintText: AppString.enterAmount,
                      labelText: AppString.enterAmount,
                    )).paddingOnly(
                  top: AppSize.appSize10,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.propertyUnique,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      controller:
                          pgPostPropertyController.pgDescribePropertyController,
                      focusNode:
                          pgPostPropertyController.pgDescribePropertyFocusNode,
                      hasFocus: pgPostPropertyController
                          .hasPgDescribePropertyFocus.value,
                      hasInput: pgPostPropertyController
                          .hasPgDescribePropertyInput.value,
                      hintText: AppString.describeProperty,
                      labelText: AppString.describeProperty,
                    )).paddingOnly(
                  top: AppSize.appSize10,
                )
              ],
            ).paddingOnly(
              top: AppSize.appSize25,
            ),
            Obx(() => Column(
                      children: [
                        CheckboxListTile(
                          title: const Text("Electricity Charges Excluded"),
                          value: pgPostPropertyController
                              .electricityExcluded.value,
                          onChanged: (val) {
                            pgPostPropertyController.electricityExcluded.value =
                                val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Water Charges Excluded"),
                          value: pgPostPropertyController.waterExcluded.value,
                          onChanged: (val) {
                            pgPostPropertyController.waterExcluded.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Price Negotiable"),
                          value: pgPostPropertyController.priceNegotiable.value,
                          onChanged: (val) {
                            pgPostPropertyController.priceNegotiable.value =
                                val!;
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
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CommonButton(
                onPressed: () async {
                  await pgPostPropertyController.submitPgDetailsStep3();
                  if (pgPostPropertyController.isPgDetailSubmittedStep3) {
                    //  pgPostPropertyController.resetStepProgress();
                    pgPostPropertyController.saveCurrentStep(4);
                    pgPostPropertyController.currentStep.value = 4;
                    pgPostPropertyController.update();
                  }
                },
                backgroundColor: AppColor.primaryColor,
                child: Text(
                  AppString.nextButton,
                  style: AppStyle.heading5Medium(color: AppColor.whiteColor),
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
      );
    });
  }

  Widget buildPgSectionStep4(BuildContext context) {
    // return GetBuilder<PGPostPropertyController>(
    //     builder: (pgPostPropertyImage){
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
                      pgPostPropertyController.storage.remove("pg_id");
                      pgPostPropertyController.storage.remove("property_id");
                      AppLogger.log(
                          "🧹 pg_id and property_id removed from GetStorage");
                      pgPostPropertyController.resetStepProgress();
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
                          await pgPostPropertyController
                              .submitStep4UploadImagesPgDetails(selectedImages);
                          if (pgPostPropertyController
                              .isPgDetailSubmittedStep4) {
                            pgPostPropertyController.resetStepProgress();
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: pgPostPropertyController.isUploadingStep4.value
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

  List<File> selectedImages = [];

  Future<List<File>> pickMultipleImages() async {
    try {
      PermissionStatus permissionStatus = PermissionStatus.denied;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          permissionStatus = await Permission.storage.request();
        } else {
          permissionStatus = await Permission.photos.request();
        }
      } else {
        permissionStatus = await Permission.photos.request();
      }

      if (permissionStatus.isGranted) {
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
      } else if (permissionStatus.isDenied) {
        Get.defaultDialog(
          title: "Permission Denied",
          middleText: "Permission denied. Please allow access in settings.",
          textConfirm: "OK",
          onConfirm: () => Get.back(),
        );
        return [];
      } else if (permissionStatus.isPermanentlyDenied) {
        Get.defaultDialog(
          title: "Permission Required",
          middleText:
              "Permission permanently denied. Please enable it from app settings.",
          textConfirm: "Open Settings",
          textCancel: "Cancel",
          onConfirm: () {
            openAppSettings();
            Get.back();
          },
        );
        openAppSettings();
        return [];
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.log('Error picking images: $e');
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////////------------------Project Start---------------------------------

  Widget buildProjectSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSize.appSize20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.project,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      childAspectRatio: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      // spacing: 10,
                      // alignment: WrapAlignment.start,
                      children: projectPostPropertyController
                          .projectSubTypeCategories.keys
                          .map((displayValue) {
                        String apiValue = projectPostPropertyController
                                .projectSubTypeCategories[displayValue] ??
                            "";
                        return GestureDetector(
                          onTap: () {
                            projectPostPropertyController
                                .updateSelectedProjectSubTypeCategory(
                                    displayValue);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: apiValue,
                                groupValue: projectPostPropertyController
                                    .selectedProjectSubTypeCategory.value,
                                activeColor: AppColor.primaryColor,
                                onChanged: (value) {
                                  if (value != null) {
                                    projectPostPropertyController
                                        .updateSelectedProjectSubTypeCategory(
                                            displayValue);
                                  }
                                },
                              ),
                              Flexible(
                                child: Text(
                                  displayValue,
                                  style: AppStyle.heading5Regular(
                                    color: AppColor.textColor,
                                  ),
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
              Text(
                AppString.projectDetails,
                style: AppStyle.heading2(color: AppColor.textColor),
              ).paddingOnly(top: AppSize.appSize25, bottom: AppSize.appSize10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.projectName,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        controller:
                            projectPostPropertyController.projectNameController,
                        focusNode:
                            projectPostPropertyController.projectNameFocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectNameFocus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectNameInput.value,
                        hintText: AppString.enterProjectName,
                        labelText: AppString.projectName,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.reraRegister,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        controller:
                            projectPostPropertyController.projectReraController,
                        focusNode:
                            projectPostPropertyController.projectReraFocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectReraFocus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectReraInput.value,
                        hintText: AppString.enterReraNumber,
                        labelText: AppString.reraNumber,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.reraStatus,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                    //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<ProjectDropdownItemModel>(
                        value: projectPostPropertyController
                            .selectedReraStatus.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select RERA Status",
                          style: AppStyle.heading5Regular(
                              color: AppColor.descriptionColor),
                        ),
                        items: projectPostPropertyController.reraStatusList
                            .map((item) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name,
                                style: AppStyle.heading5Regular(
                                    color: AppColor.textColor)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          projectPostPropertyController
                              .selectedReraStatus.value = newValue;
                        },
                        dropdownColor: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize15),
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
                      controller:
                          projectPostPropertyController.citySearchController,
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
                        return projectPostPropertyController.projectCityOptions
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
                        projectPostPropertyController.selectedProjectCity =
                            selectedCity;
                        projectPostPropertyController
                            .citySearchController.text = selectedCity.name;
                        projectPostPropertyController.update();
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
                    controller:
                        projectPostPropertyController.projectAreaController,
                    focusNode:
                        projectPostPropertyController.projectAreaFocusNode,
                    hasFocus:
                        projectPostPropertyController.hasProjectAreaFocus.value,
                    hasInput:
                        projectPostPropertyController.hasProjectAreaInput.value,
                    hintText: AppString.enterYourArea,
                    labelText: AppString.enterYourArea,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.zipCode,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  CommonTextField(
                    keyboardType: TextInputType.phone,
                    controller:
                        projectPostPropertyController.projectZipCodeController,
                    focusNode:
                        projectPostPropertyController.projectZipCodeFocusNode,
                    hasFocus: projectPostPropertyController
                        .hasProjectZipCodeFocus.value,
                    hasInput: projectPostPropertyController
                        .hasProjectZipCodeInput.value,
                    hintText: AppString.zipCode,
                    labelText: AppString.zipCode,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.countryName,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  CommonTextField(
                    controller: projectPostPropertyController
                        .projectCountryNameController,
                    focusNode: projectPostPropertyController
                        .projectCountryNameFocusNode,
                    hasFocus: projectPostPropertyController
                        .hasProjectCountryNameFocus.value,
                    hasInput: projectPostPropertyController
                        .hasProjectCountryNameInput.value,
                    hintText: AppString.enterCountryName,
                    labelText: AppString.countryName,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Visibility(
                        visible: projectPostPropertyController
                            .shouldShowField("SUPERBUILDUPAREA"),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppString.superBuildUpArea,
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.textColor)),
                              CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: projectPostPropertyController
                                    .projectSuperBuildUpAreaController,
                                focusNode: projectPostPropertyController
                                    .projectSuperBuildUpAreaFocusNode,
                                hasFocus: projectPostPropertyController
                                    .hasProjectSuperBuildUpAreaFocus.value,
                                hasInput: projectPostPropertyController
                                    .hasProjectSuperBuildUpAreaInput.value,
                                hintText: AppString.enterSuperBuildUpArea,
                                labelText: AppString.enterSuperBuildUpArea,
                              ).paddingOnly(top: 10),
                            ],
                          ).paddingOnly(top: AppSize.appSize25),
                        ),
                      )),
                  const SizedBox(
                    width: AppSize.appSize40,
                  ),
                  Obx(() => Visibility(
                        visible: projectPostPropertyController
                            .shouldShowField("LIFT"),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppString.noOflift,
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.textColor)),
                              CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: projectPostPropertyController
                                    .projectLiftController,
                                focusNode: projectPostPropertyController
                                    .projectLiftFocusNode,
                                hasFocus: projectPostPropertyController
                                    .hasProjectLiftFocus.value,
                                hasInput: projectPostPropertyController
                                    .hasProjectLiftInput.value,
                                hintText: AppString.addLift,
                                labelText: AppString.addLift,
                              ).paddingOnly(top: 10),
                            ],
                          ).paddingOnly(top: AppSize.appSize25),
                        ),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Visibility(
                        visible: projectPostPropertyController
                            .shouldShowField("TOTALUNIT"),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppString.totalUnit,
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.textColor)),
                              CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: projectPostPropertyController
                                    .projectTotalUnitController,
                                focusNode: projectPostPropertyController
                                    .projectTotalUnitFocusNode,
                                hasFocus: projectPostPropertyController
                                    .hasProjectTotalUnitFocus.value,
                                hasInput: projectPostPropertyController
                                    .hasProjectTotalUnitInput.value,
                                hintText: AppString.addTotalUnit,
                                labelText: AppString.addTotalUnit,
                              ).paddingOnly(top: 10),
                            ],
                          ).paddingOnly(top: AppSize.appSize25),
                        ),
                      )),
                  const SizedBox(
                    width: AppSize.appSize40,
                  ),
                  Obx(() => Visibility(
                        visible: projectPostPropertyController
                            .shouldShowField("PROJECTSIZE"),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppString.projectSize,
                                  style: AppStyle.heading4Medium(
                                      color: AppColor.textColor)),
                              CommonTextField(
                                keyboardType: TextInputType.phone,
                                controller: projectPostPropertyController
                                    .projectSizeController,
                                focusNode: projectPostPropertyController
                                    .projectSizeFocusNode,
                                hasFocus: projectPostPropertyController
                                    .hasProjectSizeFocus.value,
                                hasInput: projectPostPropertyController
                                    .hasProjectSizeInput.value,
                                hintText: AppString.addProjectSize,
                                labelText: AppString.addProjectSize,
                              ).paddingOnly(top: 10),
                            ],
                          ).paddingOnly(top: AppSize.appSize25),
                        ),
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.totalArea,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  CommonTextField(
                    keyboardType: TextInputType.phone,
                    controller: projectPostPropertyController
                        .projectTotalAreaController,
                    focusNode:
                        projectPostPropertyController.projectTotalAreaFocusNode,
                    hasFocus: projectPostPropertyController
                        .hasProjectTotalAreaFocus.value,
                    hasInput: projectPostPropertyController
                        .hasProjectTotalAreaInput.value,
                    hintText: AppString.enterTotalArea,
                    labelText: AppString.totalArea,
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Obx(
                () => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("PROPERTYCOMMERCIAL"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.propertyType,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                        //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<ProjectDropdownItemModel>(
                            value: projectPostPropertyController
                                .selectedPropertyTypeCommercialList.value,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Property Type",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: projectPostPropertyController
                                .propertyTypeCommercialList
                                .map((item) {
                              return DropdownMenuItem<ProjectDropdownItemModel>(
                                value: item,
                                child: Text(item.name,
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.textColor)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              projectPostPropertyController
                                  .selectedPropertyTypeCommercialList
                                  .value = newValue;
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("PLOLTFACING"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.facing,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                        //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: projectPostPropertyController
                                    .projectFacingOptions.keys
                                    .contains(projectPostPropertyController
                                        .selectedProjectFacing.value)
                                ? projectPostPropertyController
                                    .selectedProjectFacing.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Project Facing",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: projectPostPropertyController
                                .projectFacingOptions.keys
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
                                projectPostPropertyController
                                    .updateSelectedProjectFacing(newValue);
                              }
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("PROPERTYRESIDENTIAL"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.propertyType,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                        //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<ProjectDropdownItemModel>(
                            value: projectPostPropertyController
                                .selectedPropertyTypeResidentialList.value,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Property Type",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: projectPostPropertyController
                                .propertyTypeResidentialList
                                .map((item) {
                              return DropdownMenuItem<ProjectDropdownItemModel>(
                                value: item,
                                child: Text(item.name,
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.textColor)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                projectPostPropertyController
                                    .selectedPropertyTypeResidentialList
                                    .value = newValue;
                              }
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.projectStatus,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                    //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<ProjectDropdownItemModel>(
                        value: projectPostPropertyController
                            .selectedProjectStatusList.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Project Status",
                          style: AppStyle.heading5Regular(
                              color: AppColor.descriptionColor),
                        ),
                        items: projectPostPropertyController.projectStatusList
                            .map((item) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name,
                                style: AppStyle.heading5Regular(
                                    color: AppColor.textColor)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          projectPostPropertyController
                              .selectedProjectStatusList.value = newValue;
                        },
                        dropdownColor: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.possessionStatus,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                    //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<ProjectDropdownItemModel>(
                        value: projectPostPropertyController
                            .selectedPossessionStatusList.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Possession Status",
                          style: AppStyle.heading5Regular(
                              color: AppColor.descriptionColor),
                        ),
                        items: projectPostPropertyController
                            .possessionStatusList
                            .map((item) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name,
                                style: AppStyle.heading5Regular(
                                    color: AppColor.textColor)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            projectPostPropertyController
                                .selectedPossessionStatusList.value = newValue;
                          }
                        },
                        dropdownColor: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.developmentStage,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                    //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<ProjectDropdownItemModel>(
                        value: projectPostPropertyController
                            .selectedDevelopmentStageList.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Development Stage",
                          style: AppStyle.heading5Regular(
                              color: AppColor.descriptionColor),
                        ),
                        items: projectPostPropertyController
                            .developmentStageList
                            .map((item) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name,
                                style: AppStyle.heading5Regular(
                                    color: AppColor.textColor)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            projectPostPropertyController
                                .selectedDevelopmentStageList.value = newValue;
                          }
                        },
                        dropdownColor: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Obx(
                () => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("ZONINGSTATUSCOMMERCIAL"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.zoningStatus,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() {
                        // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                        //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<ProjectDropdownItemModel>(
                            value: projectPostPropertyController
                                .selectedZoningStatusList.value,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Zoning Status",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: projectPostPropertyController
                                .zoningStatusList
                                .map((item) {
                              return DropdownMenuItem<ProjectDropdownItemModel>(
                                value: item,
                                child: Text(item.name,
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.textColor)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                projectPostPropertyController
                                    .selectedZoningStatusList.value = newValue;
                              }
                            },
                            dropdownColor: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.permitStatus,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                    //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<ProjectDropdownItemModel>(
                        value: projectPostPropertyController
                            .selectedPermitStatusList.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Permit Status",
                          style: AppStyle.heading5Regular(
                              color: AppColor.descriptionColor),
                        ),
                        items: projectPostPropertyController.permitStatusList
                            .map((item) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name,
                                style: AppStyle.heading5Regular(
                                    color: AppColor.textColor)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            projectPostPropertyController
                                .selectedPermitStatusList.value = newValue;
                          }
                        },
                        dropdownColor: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.environmentClearance,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() {
                    // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                    //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<ProjectDropdownItemModel>(
                        value: projectPostPropertyController
                            .selectedEnvironmentClearanceList.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Permit Status",
                          style: AppStyle.heading5Regular(
                              color: AppColor.descriptionColor),
                        ),
                        items: projectPostPropertyController
                            .environmentClearanceList
                            .map((item) {
                          return DropdownMenuItem<ProjectDropdownItemModel>(
                            value: item,
                            child: Text(item.name,
                                style: AppStyle.heading5Regular(
                                    color: AppColor.textColor)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            projectPostPropertyController
                                .selectedEnvironmentClearanceList
                                .value = newValue;
                          }
                        },
                        dropdownColor: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Visibility(
                      visible: projectPostPropertyController
                          .shouldShowField("TOWERS"),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.totalTower,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                            ),
                            Obx(() => CommonTextField(
                                  keyboardType: TextInputType.phone,
                                  controller: projectPostPropertyController
                                      .projectTotalTowersController,
                                  focusNode: projectPostPropertyController
                                      .projectTotalTowersFocusNode,
                                  hasFocus: projectPostPropertyController
                                      .hasProjectTotalTowersFocus.value,
                                  hasInput: projectPostPropertyController
                                      .hasProjectTotalTowersInput.value,
                                  hintText: AppString.enterTotalTower,
                                  labelText: AppString.enterTotalTower,
                                )).paddingOnly(top: AppSize.appSize10),
                          ],
                        ).paddingOnly(top: AppSize.appSize25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSize.appSize40,
                  ),
                  Obx(
                    () => Visibility(
                      visible: projectPostPropertyController
                          .shouldShowField("FLOORS"),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.totalFloors,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                            ),
                            Obx(() => CommonTextField(
                                  keyboardType: TextInputType.phone,
                                  controller: projectPostPropertyController
                                      .projectTotalFloorsController,
                                  focusNode: projectPostPropertyController
                                      .projectTotalFloorsFocusNode,
                                  hasFocus: projectPostPropertyController
                                      .hasProjectTotalFloorsFocus.value,
                                  hasInput: projectPostPropertyController
                                      .hasProjectTotalFloorsInput.value,
                                  hintText: AppString.enterTotalFloors,
                                  labelText: AppString.enterTotalFloors,
                                )).paddingOnly(top: AppSize.appSize10),
                          ],
                        ).paddingOnly(top: AppSize.appSize25),
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
                      visible: projectPostPropertyController
                          .shouldShowField("CONFERENCEROOM"),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.noOfConferenceRooms,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                            ),
                            Obx(() => CommonTextField(
                                  keyboardType: TextInputType.phone,
                                  controller: projectPostPropertyController
                                      .projectConferenceRoomController,
                                  focusNode: projectPostPropertyController
                                      .projectConferenceRoomFocusNode,
                                  hasFocus: projectPostPropertyController
                                      .hasProjectConferenceRoomFocus.value,
                                  hasInput: projectPostPropertyController
                                      .hasProjectConferenceRoomInput.value,
                                  hintText: AppString.addConferenceRooms,
                                  labelText: AppString.addConferenceRooms,
                                )).paddingOnly(top: AppSize.appSize10),
                          ],
                        ).paddingOnly(top: AppSize.appSize25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSize.appSize40,
                  ),
                  Obx(
                    () => Visibility(
                      visible: projectPostPropertyController
                          .shouldShowField("SEATS"),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.noOfSeats,
                              style: AppStyle.heading4Medium(
                                  color: AppColor.textColor),
                            ),
                            Obx(() => CommonTextField(
                                  keyboardType: TextInputType.phone,
                                  controller: projectPostPropertyController
                                      .projectSeatsController,
                                  focusNode: projectPostPropertyController
                                      .projectSeatsFocusNode,
                                  hasFocus: projectPostPropertyController
                                      .hasProjectSeatsFocus.value,
                                  hasInput: projectPostPropertyController
                                      .hasProjectSeatsInput.value,
                                  hintText: AppString.addSeats,
                                  labelText: AppString.addSeats,
                                )).paddingOnly(top: AppSize.appSize10),
                          ],
                        ).paddingOnly(top: AppSize.appSize25),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.parkingSpaces,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor),
                        ),
                        Obx(() => CommonTextField(
                              keyboardType: TextInputType.phone,
                              controller: projectPostPropertyController
                                  .projectParkingSpacesController,
                              focusNode: projectPostPropertyController
                                  .projectParkingSpacesFocusNode,
                              hasFocus: projectPostPropertyController
                                  .hasProjectParkingSpacesFocus.value,
                              hasInput: projectPostPropertyController
                                  .hasProjectParkingSpacesInput.value,
                              hintText: AppString.addParkingSpaces,
                              labelText: AppString.addParkingSpaces,
                            )).paddingOnly(top: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize25),
                  ),
                  const SizedBox(
                    width: AppSize.appSize40,
                  ),
                  Expanded(
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
                              controller: projectPostPropertyController
                                  .projectBathRoomsController,
                              focusNode: projectPostPropertyController
                                  .projectBathRoomsFocusNode,
                              hasFocus: projectPostPropertyController
                                  .hasProjectBathRoomsFocus.value,
                              hasInput: projectPostPropertyController
                                  .hasProjectBathRoomsInput.value,
                              hintText: AppString.addBathrooms,
                              labelText: AppString.addBathrooms,
                            )).paddingOnly(top: AppSize.appSize10),
                      ],
                    ).paddingOnly(top: AppSize.appSize25),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Visibility(
                      visible: projectPostPropertyController
                          .shouldShowField("BEDROOMS"),
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
                                  controller: projectPostPropertyController
                                      .projectBedRoomsController,
                                  focusNode: projectPostPropertyController
                                      .projectBedRoomsFocusNode,
                                  hasFocus: projectPostPropertyController
                                      .hasProjectBedRoomsFocus.value,
                                  hasInput: projectPostPropertyController
                                      .hasProjectBedRoomsInput.value,
                                  hintText: AppString.addBedrooms,
                                  labelText: AppString.addBedrooms,
                                )).paddingOnly(top: AppSize.appSize10),
                          ],
                        ).paddingOnly(top: AppSize.appSize25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSize.appSize40,
                  ),
                  Obx(
                    () => Visibility(
                      visible: projectPostPropertyController
                          .shouldShowField("BALCONY"),
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
                                  controller: projectPostPropertyController
                                      .projectBalconyController,
                                  focusNode: projectPostPropertyController
                                      .projectBalconyFocusNode,
                                  hasFocus: projectPostPropertyController
                                      .hasProjectBalconyFocus.value,
                                  hasInput: projectPostPropertyController
                                      .hasProjectBalconyInput.value,
                                  hintText: AppString.addBalconies,
                                  labelText: AppString.addBalconies,
                                )).paddingOnly(top: AppSize.appSize10),
                          ],
                        ).paddingOnly(top: AppSize.appSize25),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("ROOMCONFIGURATION"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.roomConfigurationInBhk,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() => CommonTextField(
                            keyboardType: TextInputType.phone,
                            controller: projectPostPropertyController
                                .projectRoomConfigurationController,
                            focusNode: projectPostPropertyController
                                .projectRoomConfigurationFocusNode,
                            hasFocus: projectPostPropertyController
                                .hasProjectRoomConfigurationFocus.value,
                            hasInput: projectPostPropertyController
                                .hasProjectRoomConfigurationInput.value,
                            hintText: AppString.enterBhk,
                            labelText: AppString.enterBhk,
                          )).paddingOnly(top: AppSize.appSize10),
                    ],
                  ).paddingOnly(top: AppSize.appSize25),
                ),
              ),
              Obx(() => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("AMENITIESCOMMERCIAL"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.commonAmenities,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      Obx(() {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 1,
                          children: projectPostPropertyController
                              .commercialAmenities.keys
                              .map((amenity) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: projectPostPropertyController
                                        .selectedCommercialAmenitiesValues
                                        .contains(projectPostPropertyController
                                            .commercialAmenities[amenity]),
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (value) {
                                      projectPostPropertyController
                                          .toggleCommercialAmenities(amenity);
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      amenity,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ).paddingOnly(top: AppSize.appSize25))),
              Obx(() => Visibility(
                  visible: projectPostPropertyController
                      .shouldShowField("AMENITIESRESIDENTIAL"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.commonAmenities,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      Obx(() {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 1,
                          children: projectPostPropertyController
                              .residentialAmenities.keys
                              .map((amenity) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: projectPostPropertyController
                                        .selectedResidentialAmenitiesValues
                                        .contains(projectPostPropertyController
                                            .residentialAmenities[amenity]),
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (value) {
                                      projectPostPropertyController
                                          .toggleResidentialAmenities(amenity);
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      amenity,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ).paddingOnly(top: AppSize.appSize25))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppString.projectDescription,
                      style:
                          AppStyle.heading4Medium(color: AppColor.textColor)),
                  TextField(
                    controller: projectPostPropertyController
                        .projectDescriptionController,
                    focusNode: projectPostPropertyController
                        .projectDescriptionFocusNode,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: 'Project Description',
                      hintText: 'Enter your project description here .....',
                      labelStyle: const TextStyle(
                        color: AppColor.primaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColor.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                    ),
                  ).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),
              Obx(() => Visibility(
                  visible:
                      projectPostPropertyController.shouldShowField("Next"),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: CommonButton(
                      onPressed: () async {
                        await projectPostPropertyController
                            .submitProjectDetailStep1();
                        if (projectPostPropertyController
                            .isProjectDetailSubmitted) {
                          projectPostPropertyController
                              .projectCurrentStep.value = 2;
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
                  )))
            ],
          ),
        );
      },
    );
  }

  Widget buildProjectSectionStep2(BuildContext context) {
    return GetBuilder<ProjectPostPropertyController>(
        builder: (projectPostPropertyControllerStep2) {
      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSize.appSize20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.developerName,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        controller: projectPostPropertyController
                            .projectDeveloperNameController,
                        focusNode: projectPostPropertyController
                            .projectDeveloperNameFocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectDeveloperNameFocus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectDeveloperNameInput.value,
                        hintText: AppString.enterDeveloperName,
                        labelText: AppString.enterDeveloperName,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.developerPhoneNumber1,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        keyboardType: TextInputType.phone,
                        controller: projectPostPropertyController
                            .projectDeveloperPhoneNumber1Controller,
                        focusNode: projectPostPropertyController
                            .projectDeveloperPhoneNumber1FocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectDeveloperPhoneNumber1Focus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectDeveloperPhoneNumber1Input.value,
                        hintText: AppString.enterDeveloperPhoneNumber1,
                        labelText: AppString.enterDeveloperPhoneNumber1,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.developerPhoneNumber2,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        keyboardType: TextInputType.phone,
                        controller: projectPostPropertyController
                            .projectDeveloperPhoneNumber2Controller,
                        focusNode: projectPostPropertyController
                            .projectDeveloperPhoneNumber2FocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectDeveloperPhoneNumber2Focus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectDeveloperPhoneNumber2Input.value,
                        hintText: AppString.enterDeveloperPhoneNumber2,
                        labelText: AppString.enterDeveloperPhoneNumber2,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.developerEmailAddress1,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: projectPostPropertyController
                            .projectDeveloperEmailAddress1Controller,
                        focusNode: projectPostPropertyController
                            .projectDeveloperEmailAddress1FocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectDeveloperEmailAddress1Focus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectDeveloperEmailAddress1Input.value,
                        hintText: AppString.enterDeveloperEmailAddress1,
                        labelText: AppString.enterDeveloperEmailAddress1,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.developerEmailAddress2,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: projectPostPropertyController
                            .projectDeveloperEmailAddress2Controller,
                        focusNode: projectPostPropertyController
                            .projectDeveloperEmailAddress2FocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectDeveloperEmailAddress2Focus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectDeveloperEmailAddress2Input.value,
                        hintText: AppString.enterDeveloperEmailAddress2,
                        labelText: AppString.enterDeveloperEmailAddress2,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize25),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.contactPersonName,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        controller: projectPostPropertyController
                            .projectContactPersonNameController,
                        focusNode: projectPostPropertyController
                            .projectContactPersonNameFocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectContactPersonNameFocus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectContactPersonNameInput.value,
                        hintText: AppString.enterContactPersonName,
                        labelText: AppString.enterContactPersonName,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.contactPersonPhoneNumber,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        keyboardType: TextInputType.phone,
                        controller: projectPostPropertyController
                            .projectContactPersonPhoneNumberController,
                        focusNode: projectPostPropertyController
                            .projectContactPersonPhoneNumberFocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectContactPersonPhoneNumberFocus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectContactPersonPhoneNumberInput.value,
                        hintText: AppString.enterContactPersonPhoneNumber,
                        labelText: AppString.enterContactPersonPhoneNumber,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.contactPersonEmail,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Obx(() => CommonTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: projectPostPropertyController
                            .projectContactPersonEmailController,
                        focusNode: projectPostPropertyController
                            .projectContactPersonEmailFocusNode,
                        hasFocus: projectPostPropertyController
                            .hasProjectContactPersonEmailFocus.value,
                        hasInput: projectPostPropertyController
                            .hasProjectContactPersonEmailInput.value,
                        hintText: AppString.enterContactPersonEmail,
                        labelText: AppString.enterContactPersonEmail,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize10),

              // --- NEXT BUTTON ---
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CommonButton(
                  onPressed: () async {
                    await projectPostPropertyControllerStep2
                        .submitProjectDetailsStep2();
                    if (projectPostPropertyControllerStep2
                        .isProjectDetailSubmittedStep2) {
                      projectPostPropertyControllerStep2
                          .projectCurrentStep.value = 3;
                      projectPostPropertyControllerStep2.update();
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
                    top: AppSize.appSize25),
              ),
            ],
          ),
        );
      });
    });
  }

  Widget buildProjectSectionStep3(BuildContext context) {
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
                  AppString.tokenAmount,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectTokenAmountController,
                      focusNode: projectPostPropertyController
                          .projectTokenAmountFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectTokenAmountFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectTokenAmountInput.value,
                      hintText: AppString.enterTokenAmount,
                      labelText: AppString.enterTokenAmount,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.propertyTax,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectPropertyTaxController,
                      focusNode: projectPostPropertyController
                          .projectPropertyTaxFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectPropertyTaxFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectPropertyTaxInput.value,
                      hintText: AppString.enterPropertyTax,
                      labelText: AppString.enterPropertyTax,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.maintenanceFee,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectMaintenanceFeeController,
                      focusNode: projectPostPropertyController
                          .projectMaintenanceFeeFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectMaintenanceFeeFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectMaintenanceFeeInput.value,
                      hintText: AppString.enterMaintenanceFee,
                      labelText: AppString.enterMaintenanceFee,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.additionalFee,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectAdditionalFeeController,
                      focusNode: projectPostPropertyController
                          .projectAdditionalFeeFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectAdditionalFeeFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectAdditionalFeeInput.value,
                      hintText: AppString.enterAdditionalFee,
                      labelText: AppString.enterAdditionalFee,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.priceRange,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      controller: projectPostPropertyController
                          .projectPriceRangeController,
                      focusNode: projectPostPropertyController
                          .projectPriceRangeFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectPriceRangeFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectPriceRangeInput.value,
                      hintText: AppString.enterPriceRange,
                      labelText: AppString.enterPriceRange,
                    )).paddingOnly(top: AppSize.appSize25),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.occupancyRate,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectOccupancyRateController,
                      focusNode: projectPostPropertyController
                          .projectOccupancyRateFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectOccupancyRateFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectOccupancyRateInput.value,
                      hintText: AppString.enterOccupancyRate,
                      labelText: AppString.enterOccupancyRate,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.annualRentalIncome,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectAnnualRentalIncomeController,
                      focusNode: projectPostPropertyController
                          .projectAnnualRentalIncomeFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectAnnualRentalIncomeFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectAnnualRentalIncomeInput.value,
                      hintText: AppString.enterAnnualRentalIncome,
                      labelText: AppString.enterAnnualRentalIncome,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.currentValuation,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() => CommonTextField(
                      keyboardType: TextInputType.phone,
                      controller: projectPostPropertyController
                          .projectCurrentValuationController,
                      focusNode: projectPostPropertyController
                          .projectCurrentValuationFocusNode,
                      hasFocus: projectPostPropertyController
                          .hasProjectCurrentValuationFocus.value,
                      hasInput: projectPostPropertyController
                          .hasProjectCurrentValuationInput.value,
                      hintText: AppString.enterCurrentValuation,
                      labelText: AppString.enterCurrentValuation,
                    )).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CommonButton(
                onPressed: () async {
                  await projectPostPropertyController
                      .submitProjectDetailsStep3();
                  if (projectPostPropertyController
                      .isProjectDetailSubmittedStep3) {
                    projectPostPropertyController.saveProjectCurrentStep(4);
                    projectPostPropertyController.projectCurrentStep.value = 4;
                    projectPostPropertyController.update();
                  }
                },
                backgroundColor: AppColor.primaryColor,
                child: Text(
                  AppString.nextButton,
                  style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                ),
              ).paddingOnly(
                left: AppSize.appSize16,
                right: AppSize.appSize16,
                bottom: AppSize.appSize26,
                top: AppSize.appSize25,
              ),
            )
          ],
        ),
      );
    });
  }

  Widget buildProjectSectionStep4(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      physics: const BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColor.descriptionColor)),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Upload Images",
                      style:
                          AppStyle.heading3SemiBold(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      right: AppSize.appSize10,
                      left: AppSize.appSize10),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      projectPostPropertyController.storage
                          .remove("project_id");
                      projectPostPropertyController.storage
                          .remove("project_property_id");
                      debugPrint(
                          "project_id and project_property_id removed from GetStorage");
                      projectPostPropertyController.projectResetStepProgress();
                      Get.find<HomeController>().fetchPostProjectListing();
                      Get.find<HomeController>().fetchPostPropertyList();
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
                    )),
              ).paddingAll(AppSize.appSize10)
            ]),
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
                  debugPrint("Upload clicked");
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
                          await projectPostPropertyController
                              .submitProjectDetailsStep4Images(selectedImages);
                          if (projectPostPropertyController
                              .isProjectDetailSubmittedStep4) {
                            projectPostPropertyController
                                .projectResetStepProgress();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child:
                            projectPostPropertyController.isLoadingStep4.value
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

//////////////////////////////////////////////////////////////////////////////////------------------Project End---------------------------------

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addPropertyDetailsView);
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          AppString.nextButton,
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

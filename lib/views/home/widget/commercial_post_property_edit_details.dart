import 'dart:io';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api_service/print_logger.dart';
import '../../../common/common_button.dart';
import '../../../common/common_textfield.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/commercial_post_edit_property_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/city_model.dart';
import '../../../model/post_property_model.dart';
import '../../../routes/app_routes.dart';

class PostCommercialPropertyEditDetails extends StatelessWidget {
  final CommercialPostEditPropertyController
      commercialPostEditPropertyController =
      Get.find<CommercialPostEditPropertyController>();

  PostCommercialPropertyEditDetails({super.key}) {
    commercialPostEditPropertyController.commercialCurrentStep.value = 1;

    final PostPropertyData? commercialItem = Get.arguments;
    if (commercialItem != null) {
      commercialPostEditPropertyController
          .setEditCommercialData(commercialItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildCommercialStepWiseForm(context).paddingOnly(
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

  Widget buildCommercialStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (
          commercialPostEditPropertyController.commercialCurrentStep.value) {
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
                    children: commercialPostEditPropertyController
                        .commercialTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = commercialPostEditPropertyController
                              .commercialTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          commercialPostEditPropertyController
                              .updateSelectedCommercialTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: commercialPostEditPropertyController
                                  .selectedCommercialTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  commercialPostEditPropertyController
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
                    children: commercialPostEditPropertyController
                        .commercialSubTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = commercialPostEditPropertyController
                              .commercialSubTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          commercialPostEditPropertyController
                              .updateSelectedCommercialSubTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: commercialPostEditPropertyController
                                  .selectedCommercialSubTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("DETAILS"),
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
                    visible: commercialPostEditPropertyController
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
                                controller: commercialPostEditPropertyController
                                    .commercialSeatController,
                                focusNode: commercialPostEditPropertyController
                                    .commercialSeatFocusNode,
                                hasFocus: commercialPostEditPropertyController
                                    .hasCommercialSeatFocus.value,
                                hasInput: commercialPostEditPropertyController
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
                    visible: commercialPostEditPropertyController
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
                                controller: commercialPostEditPropertyController
                                    .commercialCabinController,
                                focusNode: commercialPostEditPropertyController
                                    .commercialCabinFocusNode,
                                hasFocus: commercialPostEditPropertyController
                                    .hasCommercialCabinFocus.value,
                                hasInput: commercialPostEditPropertyController
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
                    visible: commercialPostEditPropertyController
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
                                controller: commercialPostEditPropertyController
                                    .commercialMeetingRoomController,
                                focusNode: commercialPostEditPropertyController
                                    .commercialMeetingRoomFocusNode,
                                hasFocus: commercialPostEditPropertyController
                                    .hasCommercialMeetingRoomFocus.value,
                                hasInput: commercialPostEditPropertyController
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
                    visible: commercialPostEditPropertyController
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
                                controller: commercialPostEditPropertyController
                                    .commercialConferenceRoomController,
                                focusNode: commercialPostEditPropertyController
                                    .commercialConferenceRoomFocusNode,
                                hasFocus: commercialPostEditPropertyController
                                    .hasCommercialConferenceRoomFocus.value,
                                hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                          controller: commercialPostEditPropertyController
                              .commercialWashroomController,
                          focusNode: commercialPostEditPropertyController
                              .commercialWashroomFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialWashroomFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialReceptionAreaCategories.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                      .commercialReceptionAreaCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialReceptionAreaCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue: commercialPostEditPropertyController
                                      .selectedCommercialReceptionAreaCategory
                                      .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialTypeOfSpace.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialTypeOfSpace[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialTypeOfSpace(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialTypeOfSpace.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
                                          .updateSelectedCommercialTypeOfSpace(
                                              displayValue);
                                      print(
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialShopLocatedInside.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialShopLocatedInside[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialShopLocatedInside(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialShopLocatedInside
                                          .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
                                          .updateSelectedCommercialShopLocatedInside(
                                              displayValue);
                                      print(
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialTypeOfPlotLand.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialTypeOfPlotLand[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialTypeOfPlotLand(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialTypeOfPlotLand
                                          .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
                                          .updateSelectedCommercialTypeOfPlotLand(
                                              displayValue);
                                      print(
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialTypeOfStorage.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialTypeOfStorage[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialTypeOfStorage(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialTypeOfStorage
                                          .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
                                          .updateSelectedCommercialTypeOfStorage(
                                              displayValue);
                                      print(
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
                visible: commercialPostEditPropertyController
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
                          controller: commercialPostEditPropertyController
                              .commercialPlotAreaController,
                          focusNode: commercialPostEditPropertyController
                              .commercialPlotAreaFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialPlotAreaFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("BUILDUP"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.buildupAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostEditPropertyController
                              .commercialBuildUpAreaController,
                          focusNode: commercialPostEditPropertyController
                              .commercialBuildUpAreaFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialBuildUpAreaFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("CARPET"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.carpetAreaInSqFt,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostEditPropertyController
                              .commercialCarpetAreaController,
                          focusNode: commercialPostEditPropertyController
                              .commercialCarpetAreaFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialCarpetAreaFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                          controller: commercialPostEditPropertyController
                              .commercialWidthOfFacingRoadController,
                          focusNode: commercialPostEditPropertyController
                              .commercialWidthOfFacingRoadFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialWidthOfFacingRoadFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialPlotFacing.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialPlotFacing[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialPlotFacing(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialPlotFacing.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
                                          .updateSelectedCommercialPlotFacing(
                                              displayValue);
                                      print(
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("TOTALFLOOR"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.totalFloors,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      // print("Selected Total Floor: ${commercialPostEditPropertyController.selectedTotalFloor.value}");
                      //print("Available Floor Options: ${commercialPostEditPropertyController.totalFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: commercialPostEditPropertyController
                                  .totalFloorOptions.keys
                                  .contains(commercialPostEditPropertyController
                                      .selectedTotalFloor.value)
                              ? commercialPostEditPropertyController
                                  .selectedTotalFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Total Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: commercialPostEditPropertyController
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
                              commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("PROPERTYFLOOR"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyFloors,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      // print("Selected Property Floor: ${commercialPostEditPropertyController.selectedPropertyFloor.value}");
                      //print("Available Property Floor: ${commercialPostEditPropertyController.propertyFloorOptions.keys.toList()}");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: commercialPostEditPropertyController
                                  .propertyFloorOptions.keys
                                  .contains(commercialPostEditPropertyController
                                      .selectedPropertyFloor.value)
                              ? commercialPostEditPropertyController
                                  .selectedPropertyFloor.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Property Floors",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: commercialPostEditPropertyController
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
                              commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                                commercialPostEditPropertyController.furnishing,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            // onChanged: (val) => commercialPostEditPropertyController.updateFacility(commercialPostEditPropertyController.furnishing, val)
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController.furnishing,
                                val,
                              );
                              AppLogger.log(
                                  "Furnishing selected value: ${commercialPostEditPropertyController.furnishing.value}");
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
                                commercialPostEditPropertyController.centralAC,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController.centralAC,
                                val,
                              );
                              AppLogger.log(
                                  "Central AC selected value: ${commercialPostEditPropertyController.centralAC.value}");
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
                                commercialPostEditPropertyController.oxygenDuct,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController.oxygenDuct,
                                val,
                              );
                              AppLogger.log(
                                  "OxyGen Duct selected value: ${commercialPostEditPropertyController.oxygenDuct.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "UPS",
                            selectedValue:
                                commercialPostEditPropertyController.ups,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController.ups,
                                val,
                              );
                              AppLogger.log(
                                  "UPS selected value: ${commercialPostEditPropertyController.ups.value}");
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
                visible: commercialPostEditPropertyController
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
                            selectedValue: commercialPostEditPropertyController
                                .fireExtension,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            // onChanged: (val) => commercialPostEditPropertyController.updateFacility(commercialPostEditPropertyController.furnishing, val)
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController
                                    .fireExtension,
                                val,
                              );
                              AppLogger.log(
                                  "fireExtension value: ${commercialPostEditPropertyController.fireExtension.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Fire Sprinklers",
                            selectedValue: commercialPostEditPropertyController
                                .fireSprinklers,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController
                                    .fireSprinklers,
                                val,
                              );
                              AppLogger.log(
                                  "fireSprinklers selected value: ${commercialPostEditPropertyController.fireSprinklers.value}");
                            },
                          ),
                        ],
                      ).paddingOnly(
                          top: AppSize.appSize15, left: AppSize.appSize15),
                      Column(
                        children: [
                          facilityRadioField(
                            title: "Fire Sensors",
                            selectedValue: commercialPostEditPropertyController
                                .fireSensors,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController
                                    .fireSensors,
                                val,
                              );
                              AppLogger.log(
                                  "fireSensors selected value: ${commercialPostEditPropertyController.fireSensors.value}");
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
                                commercialPostEditPropertyController.fireHose,
                            options: commercialPostEditPropertyController
                                .facilityOptions,
                            onChanged: (val) {
                              commercialPostEditPropertyController
                                  .updateFacility(
                                commercialPostEditPropertyController.fireHose,
                                val,
                              );
                              AppLogger.log(
                                  "fireHose selected value: ${commercialPostEditPropertyController.fireHose.value}");
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
                visible: commercialPostEditPropertyController
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
                        children: commercialPostEditPropertyController
                            .commercialAvailability.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialAvailability[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialAvailability(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialAvailability.value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("PARKING"),
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
                        children: commercialPostEditPropertyController
                            .commercialParkingStatus.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                  .commercialParkingStatus[displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialParkingStatus(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: apiValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialParkingStatus
                                          .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
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
              final subtypeKey = commercialPostEditPropertyController
                      .commercialSubTypeCategories.entries
                      .firstWhereOrNull((entry) =>
                          entry.value ==
                          commercialPostEditPropertyController
                              .selectedCommercialSubTypeCategory.value)
                      ?.key ??
                  "";

              final label = subtypeKey == "Office"
                  ? AppString.pantryType
                  : AppString.washroomType;

              return Visibility(
                visible: commercialPostEditPropertyController
                    .shouldShowField("PANTRY"),
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
                        children: commercialPostEditPropertyController
                            .commercialPantryTypeCategories.keys
                            .map((displayValue) {
                          String apiValue = commercialPostEditPropertyController
                                      .commercialPantryTypeCategories[
                                  displayValue] ??
                              "";
                          return GestureDetector(
                            onTap: () {
                              commercialPostEditPropertyController
                                  .updateSelectedCommercialPantryTypeCategory(
                                      displayValue);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: displayValue,
                                  groupValue:
                                      commercialPostEditPropertyController
                                          .selectedCommercialPantryTypeCategory
                                          .value,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    if (value != null) {
                                      commercialPostEditPropertyController
                                          .updateSelectedCommercialPantryTypeCategory(
                                              displayValue);
                                      print(
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
                visible: commercialPostEditPropertyController
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
                          controller: commercialPostEditPropertyController
                              .commercialStairCaseController,
                          focusNode: commercialPostEditPropertyController
                              .commercialStairCaseFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialStairCaseFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("LIFT"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.noOflift,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: commercialPostEditPropertyController
                              .commercialLiftController,
                          focusNode: commercialPostEditPropertyController
                              .commercialLiftFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialLiftFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
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
                          controller: commercialPostEditPropertyController
                              .commercialAgeOfPropertyController,
                          focusNode: commercialPostEditPropertyController
                              .commercialAgeOfPropertyFocusNode,
                          hasFocus: commercialPostEditPropertyController
                              .hasCommercialAgeOfPropertyFocus.value,
                          hasInput: commercialPostEditPropertyController
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
                visible: commercialPostEditPropertyController
                    .shouldShowField("Next"),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CommonButton(
                    onPressed: () async {
                      await commercialPostEditPropertyController
                          .submitEditCommercialDetailStep1();
                      if (commercialPostEditPropertyController
                          .isCommercialDetailSubmitted) {
                        commercialPostEditPropertyController
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
    return GetBuilder<CommercialPostEditPropertyController>(
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
                        .submitEditCommercialDetailsStep2();
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
                      controller: commercialPostEditPropertyController
                          .commercialRentAmountController,
                      focusNode: commercialPostEditPropertyController
                          .commercialRentAmountFocusNode,
                      hasFocus: commercialPostEditPropertyController
                          .hasCommercialRentAmountFocus.value,
                      hasInput: commercialPostEditPropertyController
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
                          value: commercialPostEditPropertyController
                              .allInclusivePrice.value,
                          onChanged: (val) {
                            commercialPostEditPropertyController
                                .allInclusivePrice.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Tax and Govt. charges excluded"),
                          value: commercialPostEditPropertyController
                              .taxAndGovtChargesExcluded.value,
                          onChanged: (val) {
                            commercialPostEditPropertyController
                                .taxAndGovtChargesExcluded.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Price is Negotiable"),
                          value: commercialPostEditPropertyController
                              .priceNegotiable.value,
                          onChanged: (val) {
                            commercialPostEditPropertyController
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
                children: commercialPostEditPropertyController
                    .commercialOwnerShipCategories.keys
                    .map((displayValue) {
                  String apiValue = commercialPostEditPropertyController
                          .commercialOwnerShipCategories[displayValue] ??
                      "";
                  return GestureDetector(
                    onTap: () {
                      commercialPostEditPropertyController
                          .updateSelectedCommercialOwnerShipCategory(
                              displayValue);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: displayValue,
                          groupValue: commercialPostEditPropertyController
                              .selectedCommercialOwnerShipCategory.value,
                          activeColor: AppColor.primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              commercialPostEditPropertyController
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
                      controller: commercialPostEditPropertyController
                          .commercialDescribePropertyController,
                      focusNode: commercialPostEditPropertyController
                          .commercialDescribePropertyFocusNode,
                      hasFocus: commercialPostEditPropertyController
                          .hasCommercialDescribePropertyFocus.value,
                      hasInput: commercialPostEditPropertyController
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
                  await commercialPostEditPropertyController
                      .submitEditCommercialDetailsStep3();
                  if (commercialPostEditPropertyController
                      .isCommercialDetailSubmittedStep3) {
                    commercialPostEditPropertyController
                        .commercialCurrentStep.value = 4;
                    commercialPostEditPropertyController.update();
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

  List<File> selectedImages = [];

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
                          await commercialPostEditPropertyController
                              .submitEditCommercialDetailsStep4Images(
                                  selectedImages);
                          if (commercialPostEditPropertyController
                              .isCommercialDetailSubmittedStep4) {
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: commercialPostEditPropertyController
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
}

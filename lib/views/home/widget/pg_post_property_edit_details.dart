import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../api_service/print_logger.dart';
import '../../../common/common_button.dart';
import '../../../common/common_textfield.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/pg_post_edit_property_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/city_model.dart';
import '../../../model/post_property_model.dart';
import '../../../routes/app_routes.dart';

class PostPGPropertyEditDetails extends StatelessWidget {
  final PGPostEditPropertyController pgEditPropertyController =
      Get.find<PGPostEditPropertyController>();

  PostPGPropertyEditDetails({
    super.key,
  }) {
    pgEditPropertyController.currentStep.value = 1;

    final PostPropertyData? pgItem = Get.arguments;

    if (pgItem != null) {
      pgEditPropertyController.loadCityList().then((_) {
        pgEditPropertyController.setEditData(pgItem!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildPgStepWiseForm(context).paddingOnly(
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

  Widget buildPgStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (pgEditPropertyController.currentStep.value) {
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
                                pgEditPropertyController.editPgNameController,
                            focusNode:
                                pgEditPropertyController.editPgNameFocusNode,
                            hasFocus: pgEditPropertyController
                                .hasEditPgNameFocus.value,
                            hasInput: pgEditPropertyController
                                .hasEditPgNameInput.value,
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
                            value: pgEditPropertyController
                                        .selectedPgRoom.value.isNotEmpty ==
                                    true
                                ? pgEditPropertyController.selectedPgRoom.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Room Type",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: pgEditPropertyController.pgRoomOptions
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
                                pgEditPropertyController
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
                              pgEditPropertyController.selectDate(context),
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
                                  pgEditPropertyController.selectedDate.value !=
                                          null
                                      ? "${pgEditPropertyController.selectedDate.value!.day}/${pgEditPropertyController.selectedDate.value!.month}/${pgEditPropertyController.selectedDate.value!.year}"
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
                          children: pgEditPropertyController.pgCategories.keys
                              .map((displayValue) {
                            String apiValue = pgEditPropertyController
                                    .pgCategories[displayValue] ??
                                "";
                            return GestureDetector(
                              onTap: () {
                                pgEditPropertyController
                                    .updateSelectedPgCategory(displayValue);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: apiValue,
                                    groupValue: pgEditPropertyController
                                        .selectedPgCategory.value,
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (value) {
                                      if (value != null) {
                                        pgEditPropertyController
                                            .updateSelectedPgCategory(
                                                displayValue);
                                      }
                                    },
                                  ),
                                  Text(
                                    displayValue,
                                    style: AppStyle.heading5Regular(
                                      color: pgEditPropertyController
                                                  .selectedPgCategory.value ==
                                              apiValue
                                          ? AppColor.primaryColor
                                          : AppColor.textColor,
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
                          children: pgEditPropertyController.houseRules.keys
                              .map((rule) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return Checkbox(
                                      value: pgEditPropertyController
                                          .selectedHouseRulesValues
                                          .contains(pgEditPropertyController
                                              .houseRules[rule]),
                                      activeColor: AppColor.primaryColor,
                                      onChanged: (value) {
                                        pgEditPropertyController
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
                          children: pgEditPropertyController
                              .commonAmenities.keys
                              .map((amenity) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: pgEditPropertyController
                                        .selectedCommonAmenitiesValues
                                        .contains(pgEditPropertyController
                                            .commonAmenities[amenity]),
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (value) {
                                      pgEditPropertyController
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
                        //print("Selected Total Floor: ${pgPostPropertyController.selectedTotalFloor.value}");
                        // print("Available Floor Options: ${pgPostPropertyController.totalFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: pgEditPropertyController
                                    .totalFloorOptions.keys
                                    .contains(pgEditPropertyController
                                        .selectedTotalFloor.value)
                                ? pgEditPropertyController
                                    .selectedTotalFloor.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Total Floors",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: pgEditPropertyController
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
                                pgEditPropertyController
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
                        // print("Selected Property Floor: ${pgPostPropertyController.selectedPropertyFloor.value}");
                        // print("Available Property Floor: ${pgPostPropertyController.propertyFloorOptions.keys.toList()}");
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: pgEditPropertyController
                                    .propertyFloorOptions.keys
                                    .contains(pgEditPropertyController
                                        .selectedPropertyFloor.value)
                                ? pgEditPropertyController
                                    .selectedPropertyFloor.value
                                : null,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Property Floors",
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ),
                            items: pgEditPropertyController
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
                                pgEditPropertyController
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
                    child: CommonButton(
                      onPressed: () async {
                        await pgEditPropertyController
                            .submitEditPgDetailsStep1();
                        if (pgEditPropertyController.isPgDetailSubmitted) {
                          pgEditPropertyController.currentStep.value = 2;
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
          ));
    });
  }

  Widget buildPgSectionStep2(BuildContext context) {
    return GetBuilder<PGPostEditPropertyController>(
      builder: (controller) {
        AppLogger.log(
            "Selected City: ${pgEditPropertyController.selectedPgCity?.name}");

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
                        ),
                      ),
                    ],
                  ).paddingOnly(top: AppSize.appSize10),

                  // --- AREA INPUT ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.area,
                          style: AppStyle.heading4Medium(
                              color: AppColor.textColor)),
                      CommonTextField(
                        controller: controller.editPgAreaController,
                        focusNode: controller.editPgAreaFocusNode,
                        hasFocus: controller.hasEditPgAreaFocus.value,
                        hasInput: controller.hasEditPgAreaInput.value,
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
                              color: AppColor.textColor)),
                      CommonTextField(
                        controller: controller.editPgSubLocalityController,
                        focusNode: controller.editPgSubLocalityFocusNode,
                        hasFocus: controller.hasEditPgSubLocalityFocus.value,
                        hasInput: controller.hasEditPgSubLocalityInput.value,
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
                              color: AppColor.textColor)),
                      CommonTextField(
                        controller: controller.editPgHouseNoController,
                        focusNode: controller.editPgHouseNoFocusNode,
                        hasFocus: controller.hasEditPgHouseNoFocus.value,
                        hasInput: controller.hasEditPgHouseNoInput.value,
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
                              color: AppColor.textColor)),
                      CommonTextField(
                        keyboardType: TextInputType.number,
                        controller: controller.editPgZipCodeController,
                        focusNode: controller.editPgZipCodeFocusNode,
                        hasFocus: controller.hasEditPgZipCodeFocus.value,
                        hasInput: controller.hasEditPgZipCodeInput.value,
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
                        await controller.submitEditPgDetailsStep2();
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
                          pgEditPropertyController.editPgRentAmountController,
                      focusNode:
                          pgEditPropertyController.editPgRentAmountFocusNode,
                      hasFocus: pgEditPropertyController
                          .hasEditPgRentAmountFocus.value,
                      hasInput: pgEditPropertyController
                          .hasEditPgRentAmountInput.value,
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
                      controller: pgEditPropertyController
                          .editPgDescribePropertyController,
                      focusNode: pgEditPropertyController
                          .editPgDescribePropertyFocusNode,
                      hasFocus: pgEditPropertyController
                          .hasEditPgDescribePropertyFocus.value,
                      hasInput: pgEditPropertyController
                          .hasEditPgDescribePropertyInput.value,
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
                          value: pgEditPropertyController
                              .electricityExcluded.value,
                          onChanged: (val) {
                            pgEditPropertyController.electricityExcluded.value =
                                val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Water Charges Excluded"),
                          value: pgEditPropertyController.waterExcluded.value,
                          onChanged: (val) {
                            pgEditPropertyController.waterExcluded.value = val!;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Price Negotiable"),
                          value: pgEditPropertyController.priceNegotiable.value,
                          onChanged: (val) {
                            pgEditPropertyController.priceNegotiable.value =
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
                  await pgEditPropertyController.submitEditPgDetailsStep3();
                  if (pgEditPropertyController.isPgDetailSubmittedStep3) {
                    pgEditPropertyController.currentStep.value = 4;
                    pgEditPropertyController.update();
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
                          await pgEditPropertyController
                              .submitEditStep4UploadImagesPgDetails(
                                  selectedImages);
                          if (pgEditPropertyController
                              .isPgDetailSubmittedStep4) {
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: pgEditPropertyController.isUploadingStep4.value
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

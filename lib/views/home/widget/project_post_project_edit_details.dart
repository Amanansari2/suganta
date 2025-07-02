import 'dart:io';

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
import '../../../controller/home_controller.dart';
import '../../../controller/project_post_edit_project_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/city_model.dart';
import '../../../model/project_dropdown_model.dart';
import '../../../model/project_post_property_model.dart';
import '../../../routes/app_routes.dart';

class ProjectPostProjectEditDetails extends StatelessWidget {
  final ProjectPostEditProjectController postEditProjectController =
      Get.find<ProjectPostEditProjectController>();

  ProjectPostProjectEditDetails({super.key}) {
    postEditProjectController.projectCurrentStep.value = 1;

    final ProjectPostModel? projectItems = Get.arguments;
    if (projectItems != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildProjectStepWiseForm(context).paddingOnly(
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
        "Edit Project Details",
        style: AppStyle.heading3Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildProjectStepWiseForm(BuildContext context) {
    return Obx(() {
      switch (postEditProjectController.projectCurrentStep.value) {
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

  Widget buildProjectSection(BuildContext context) {
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
                    children: postEditProjectController
                        .projectSubTypeCategories.keys
                        .map((displayValue) {
                      String apiValue = postEditProjectController
                              .projectSubTypeCategories[displayValue] ??
                          "";
                      return GestureDetector(
                        onTap: () {
                          postEditProjectController
                              .updateSelectedProjectSubTypeCategory(
                                  displayValue);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: apiValue,
                              groupValue: postEditProjectController
                                  .selectedProjectSubTypeCategory.value,
                              activeColor: AppColor.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  postEditProjectController
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
                          postEditProjectController.projectNameController,
                      focusNode: postEditProjectController.projectNameFocusNode,
                      hasFocus:
                          postEditProjectController.hasProjectNameFocus.value,
                      hasInput:
                          postEditProjectController.hasProjectNameInput.value,
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
                          postEditProjectController.projectReraController,
                      focusNode: postEditProjectController.projectReraFocusNode,
                      hasFocus:
                          postEditProjectController.hasProjectReraFocus.value,
                      hasInput:
                          postEditProjectController.hasProjectReraInput.value,
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
                  final isLoading =
                      postEditProjectController.isEditLoadingDropDown.value;

                  final selectedItem = postEditProjectController
                      .editReraStatusList
                      .firstWhereOrNull(
                    (e) =>
                        e.id ==
                        postEditProjectController
                            .editSelectedReraStatus.value?.id,
                  );

                  // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                  //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                  return AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<ProjectDropdownItemModel>(
                          value: selectedItem,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select RERA Status",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController.editReraStatusList
                              .map((item) {
                            return DropdownMenuItem<ProjectDropdownItemModel>(
                              value: item,
                              child: Text(item.name,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (ProjectDropdownItemModel? newValue) {
                            if (newValue != null) {
                              postEditProjectController
                                  .editSelectedReraStatus.value = newValue;
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.city,
                    style: AppStyle.heading4Medium(color: AppColor.textColor)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TypeAheadField<City>(
                    controller: postEditProjectController.citySearchController,
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
                      return postEditProjectController.projectCityOptions
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
                      postEditProjectController.selectedProjectCity =
                          selectedCity;
                      postEditProjectController.citySearchController.text =
                          selectedCity.name;
                      postEditProjectController.update();
                    },
                  ),
                ).paddingOnly(top: 10),
              ],
            ).paddingOnly(top: AppSize.appSize10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.area,
                    style: AppStyle.heading4Medium(color: AppColor.textColor)),
                CommonTextField(
                  controller: postEditProjectController.projectAreaController,
                  focusNode: postEditProjectController.projectAreaFocusNode,
                  hasFocus: postEditProjectController.hasProjectAreaFocus.value,
                  hasInput: postEditProjectController.hasProjectAreaInput.value,
                  hintText: AppString.enterYourArea,
                  labelText: AppString.enterYourArea,
                ).paddingOnly(top: 10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.zipCode,
                    style: AppStyle.heading4Medium(color: AppColor.textColor)),
                CommonTextField(
                  keyboardType: TextInputType.phone,
                  controller:
                      postEditProjectController.projectZipCodeController,
                  focusNode: postEditProjectController.projectZipCodeFocusNode,
                  hasFocus:
                      postEditProjectController.hasProjectZipCodeFocus.value,
                  hasInput:
                      postEditProjectController.hasProjectZipCodeInput.value,
                  hintText: AppString.zipCode,
                  labelText: AppString.zipCode,
                ).paddingOnly(top: 10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.countryName,
                    style: AppStyle.heading4Medium(color: AppColor.textColor)),
                CommonTextField(
                  controller:
                      postEditProjectController.projectCountryNameController,
                  focusNode:
                      postEditProjectController.projectCountryNameFocusNode,
                  hasFocus: postEditProjectController
                      .hasProjectCountryNameFocus.value,
                  hasInput: postEditProjectController
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
                      visible: postEditProjectController
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
                              controller: postEditProjectController
                                  .projectSuperBuildUpAreaController,
                              focusNode: postEditProjectController
                                  .projectSuperBuildUpAreaFocusNode,
                              hasFocus: postEditProjectController
                                  .hasProjectSuperBuildUpAreaFocus.value,
                              hasInput: postEditProjectController
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
                      visible:
                          postEditProjectController.shouldShowField("LIFT"),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppString.noOflift,
                                style: AppStyle.heading4Medium(
                                    color: AppColor.textColor)),
                            CommonTextField(
                              keyboardType: TextInputType.phone,
                              controller: postEditProjectController
                                  .projectLiftController,
                              focusNode: postEditProjectController
                                  .projectLiftFocusNode,
                              hasFocus: postEditProjectController
                                  .hasProjectLiftFocus.value,
                              hasInput: postEditProjectController
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
                      visible: postEditProjectController
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
                              controller: postEditProjectController
                                  .projectTotalUnitController,
                              focusNode: postEditProjectController
                                  .projectTotalUnitFocusNode,
                              hasFocus: postEditProjectController
                                  .hasProjectTotalUnitFocus.value,
                              hasInput: postEditProjectController
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
                      visible: postEditProjectController
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
                              controller: postEditProjectController
                                  .projectSizeController,
                              focusNode: postEditProjectController
                                  .projectSizeFocusNode,
                              hasFocus: postEditProjectController
                                  .hasProjectSizeFocus.value,
                              hasInput: postEditProjectController
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
                    style: AppStyle.heading4Medium(color: AppColor.textColor)),
                CommonTextField(
                  keyboardType: TextInputType.phone,
                  controller:
                      postEditProjectController.projectTotalAreaController,
                  focusNode:
                      postEditProjectController.projectTotalAreaFocusNode,
                  hasFocus:
                      postEditProjectController.hasProjectTotalAreaFocus.value,
                  hasInput:
                      postEditProjectController.hasProjectTotalAreaInput.value,
                  hintText: AppString.enterTotalArea,
                  labelText: AppString.totalArea,
                ).paddingOnly(top: 10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Obx(
              () => Visibility(
                visible: postEditProjectController
                    .shouldShowField("PROPERTYCOMMERCIAL"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyType,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      final isLoading =
                          postEditProjectController.isEditLoadingDropDown.value;
                      final selectedItem = postEditProjectController
                          .editPropertyTypeCommercialList
                          .firstWhereOrNull(
                        (e) =>
                            e.id ==
                            postEditProjectController
                                .editSelectedPropertyTypeCommercialList
                                .value
                                ?.id,
                      );
                      // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                      //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                      return AbsorbPointer(
                        absorbing: isLoading,
                        child: Opacity(
                          opacity: isLoading ? 0.5 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<ProjectDropdownItemModel>(
                              value: selectedItem,
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Text(
                                "Select Property Type",
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ),
                              items: postEditProjectController
                                  .editPropertyTypeCommercialList
                                  .map((item) {
                                return DropdownMenuItem<
                                    ProjectDropdownItemModel>(
                                  value: item,
                                  child: Text(item.name,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor)),
                                );
                              }).toList(),
                              onChanged: (ProjectDropdownItemModel? newValue) {
                                if (newValue != null) {
                                  postEditProjectController
                                      .editSelectedPropertyTypeCommercialList
                                      .value = newValue;
                                }
                              },
                              dropdownColor: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    postEditProjectController.shouldShowField("PLOLTFACING"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.facing,
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
                          value: postEditProjectController
                                  .projectFacingOptions.keys
                                  .contains(postEditProjectController
                                      .selectedProjectFacing.value)
                              ? postEditProjectController
                                  .selectedProjectFacing.value
                              : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Project Facing",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController
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
                              postEditProjectController
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
                visible: postEditProjectController
                    .shouldShowField("PROPERTYRESIDENTIAL"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.propertyType,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      final isLoading =
                          postEditProjectController.isEditLoadingDropDown.value;
                      final selectedItem = postEditProjectController
                          .editPropertyTypeResidentialList
                          .firstWhereOrNull((e) =>
                              e.id ==
                              postEditProjectController
                                  .editSelectedPropertyTypeResidentialList
                                  .value
                                  ?.id);
                      // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                      //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                      return AbsorbPointer(
                        absorbing: isLoading,
                        child: Opacity(
                          opacity: isLoading ? 0.5 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<ProjectDropdownItemModel>(
                              value: selectedItem,
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Text(
                                "Select Property Type",
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ),
                              items: postEditProjectController
                                  .editPropertyTypeResidentialList
                                  .map((item) {
                                return DropdownMenuItem<
                                    ProjectDropdownItemModel>(
                                  value: item,
                                  child: Text(item.name,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor)),
                                );
                              }).toList(),
                              onChanged: (ProjectDropdownItemModel? newValue) {
                                if (newValue != null) {
                                  postEditProjectController
                                      .editSelectedPropertyTypeResidentialList
                                      .value = newValue;
                                }
                              },
                              dropdownColor: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                  final isLoading =
                      postEditProjectController.isEditLoadingDropDown.value;
                  final selectedItem = postEditProjectController
                      .editProjectStatusList
                      .firstWhereOrNull((e) =>
                          e.id ==
                          postEditProjectController
                              .editSelectedProjectStatusList.value?.id);

                  // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                  //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                  return AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<ProjectDropdownItemModel>(
                          value: selectedItem,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Project Status",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController.editProjectStatusList
                              .map((item) {
                            return DropdownMenuItem<ProjectDropdownItemModel>(
                              value: item,
                              child: Text(item.name,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (ProjectDropdownItemModel? newValue) {
                            if (newValue != null) {
                              postEditProjectController
                                  .editSelectedProjectStatusList
                                  .value = newValue;
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                  AppString.possessionStatus,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() {
                  final isLoading =
                      postEditProjectController.isEditLoadingDropDown.value;
                  final selectedItem = postEditProjectController
                      .editPossessionStatusList
                      .firstWhereOrNull((e) =>
                          e.id ==
                          postEditProjectController
                              .editSelectedPossessionStatusList.value?.id);

                  // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                  //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                  return AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<ProjectDropdownItemModel>(
                          value: selectedItem,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Possession Status",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController
                              .editPossessionStatusList
                              .map((item) {
                            return DropdownMenuItem<ProjectDropdownItemModel>(
                              value: item,
                              child: Text(item.name,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (ProjectDropdownItemModel? newValue) {
                            if (newValue != null) {
                              postEditProjectController
                                  .editSelectedPossessionStatusList
                                  .value = newValue;
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                  AppString.developmentStage,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() {
                  final isLoading =
                      postEditProjectController.isEditLoadingDropDown.value;
                  final selectedItem = postEditProjectController
                      .editDevelopmentStageList
                      .firstWhereOrNull((e) =>
                          e.id ==
                          postEditProjectController
                              .editSelectedDevelopmentStageList.value?.id);

                  // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                  //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                  return AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<ProjectDropdownItemModel>(
                          value: selectedItem,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Development Stage",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController
                              .editDevelopmentStageList
                              .map((item) {
                            return DropdownMenuItem<ProjectDropdownItemModel>(
                              value: item,
                              child: Text(item.name,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (ProjectDropdownItemModel? newValue) {
                            if (newValue != null) {
                              postEditProjectController
                                  .editSelectedDevelopmentStageList
                                  .value = newValue;
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }).paddingOnly(top: AppSize.appSize10),
              ],
            ).paddingOnly(top: AppSize.appSize25),
            Obx(
              () => Visibility(
                visible: postEditProjectController
                    .shouldShowField("ZONINGSTATUSCOMMERCIAL"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.zoningStatus,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() {
                      final isLoading =
                          postEditProjectController.isEditLoadingDropDown.value;
                      final selectedItem = postEditProjectController
                          .editZoningStatusList
                          .firstWhereOrNull((e) =>
                              e.id ==
                              postEditProjectController
                                  .editSelectedZoningStatusList.value?.id);

                      // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                      //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                      return AbsorbPointer(
                        absorbing: isLoading,
                        child: Opacity(
                          opacity: isLoading ? 0.5 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<ProjectDropdownItemModel>(
                              value: selectedItem,
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Text(
                                "Select Zoning Status",
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ),
                              items: postEditProjectController
                                  .editZoningStatusList
                                  .map((item) {
                                return DropdownMenuItem<
                                    ProjectDropdownItemModel>(
                                  value: item,
                                  child: Text(item.name,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.textColor)),
                                );
                              }).toList(),
                              onChanged: (ProjectDropdownItemModel? newValue) {
                                if (newValue != null) {
                                  postEditProjectController
                                      .editSelectedZoningStatusList
                                      .value = newValue;
                                }
                              },
                              dropdownColor: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                  final isLoading =
                      postEditProjectController.isEditLoadingDropDown.value;
                  final selectedItem = postEditProjectController
                      .editPermitStatusList
                      .firstWhereOrNull((e) =>
                          e.id ==
                          postEditProjectController
                              .editSelectedPermitStatusList.value?.id);
                  // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                  //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                  return AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<ProjectDropdownItemModel>(
                          value: selectedItem,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Permit Status",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController.editPermitStatusList
                              .map((item) {
                            return DropdownMenuItem<ProjectDropdownItemModel>(
                              value: item,
                              child: Text(item.name,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (ProjectDropdownItemModel? newValue) {
                            if (newValue != null) {
                              postEditProjectController
                                  .editSelectedPermitStatusList
                                  .value = newValue;
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                  AppString.environmentClearance,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Obx(() {
                  final isLoading =
                      postEditProjectController.isEditLoadingDropDown.value;
                  final selectedItem = postEditProjectController
                      .editEnvironmentClearanceList
                      .firstWhereOrNull((e) =>
                          e.id ==
                          postEditProjectController
                              .editSelectedEnvironmentClearanceList.value?.id);
                  // debugPrint("Selected Total Floor: ${commercialPostPropertyController.selectedTotalFloor.value}");
                  //debugPrint("Available Floor Options: ${commercialPostPropertyController.totalFloorOptions.keys.toList()}");
                  return AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<ProjectDropdownItemModel>(
                          value: selectedItem,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            "Select Permit Status",
                            style: AppStyle.heading5Regular(
                                color: AppColor.descriptionColor),
                          ),
                          items: postEditProjectController
                              .editEnvironmentClearanceList
                              .map((item) {
                            return DropdownMenuItem<ProjectDropdownItemModel>(
                              value: item,
                              child: Text(item.name,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            );
                          }).toList(),
                          onChanged: (ProjectDropdownItemModel? newValue) {
                            if (newValue != null) {
                              postEditProjectController
                                  .editSelectedEnvironmentClearanceList
                                  .value = newValue;
                            }
                          },
                          dropdownColor: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                    visible:
                        postEditProjectController.shouldShowField("TOWERS"),
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
                                controller: postEditProjectController
                                    .projectTotalTowersController,
                                focusNode: postEditProjectController
                                    .projectTotalTowersFocusNode,
                                hasFocus: postEditProjectController
                                    .hasProjectTotalTowersFocus.value,
                                hasInput: postEditProjectController
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
                    visible:
                        postEditProjectController.shouldShowField("FLOORS"),
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
                                controller: postEditProjectController
                                    .projectTotalFloorsController,
                                focusNode: postEditProjectController
                                    .projectTotalFloorsFocusNode,
                                hasFocus: postEditProjectController
                                    .hasProjectTotalFloorsFocus.value,
                                hasInput: postEditProjectController
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
                    visible: postEditProjectController
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
                                controller: postEditProjectController
                                    .projectConferenceRoomController,
                                focusNode: postEditProjectController
                                    .projectConferenceRoomFocusNode,
                                hasFocus: postEditProjectController
                                    .hasProjectConferenceRoomFocus.value,
                                hasInput: postEditProjectController
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
                    visible: postEditProjectController.shouldShowField("SEATS"),
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
                                controller: postEditProjectController
                                    .projectSeatsController,
                                focusNode: postEditProjectController
                                    .projectSeatsFocusNode,
                                hasFocus: postEditProjectController
                                    .hasProjectSeatsFocus.value,
                                hasInput: postEditProjectController
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
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() => CommonTextField(
                            keyboardType: TextInputType.phone,
                            controller: postEditProjectController
                                .projectParkingSpacesController,
                            focusNode: postEditProjectController
                                .projectParkingSpacesFocusNode,
                            hasFocus: postEditProjectController
                                .hasProjectParkingSpacesFocus.value,
                            hasInput: postEditProjectController
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
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                      Obx(() => CommonTextField(
                            keyboardType: TextInputType.phone,
                            controller: postEditProjectController
                                .projectBathRoomsController,
                            focusNode: postEditProjectController
                                .projectBathRoomsFocusNode,
                            hasFocus: postEditProjectController
                                .hasProjectBathRoomsFocus.value,
                            hasInput: postEditProjectController
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
                    visible:
                        postEditProjectController.shouldShowField("BEDROOMS"),
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
                                controller: postEditProjectController
                                    .projectBedRoomsController,
                                focusNode: postEditProjectController
                                    .projectBedRoomsFocusNode,
                                hasFocus: postEditProjectController
                                    .hasProjectBedRoomsFocus.value,
                                hasInput: postEditProjectController
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
                    visible:
                        postEditProjectController.shouldShowField("BALCONY"),
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
                                controller: postEditProjectController
                                    .projectBalconyController,
                                focusNode: postEditProjectController
                                    .projectBalconyFocusNode,
                                hasFocus: postEditProjectController
                                    .hasProjectBalconyFocus.value,
                                hasInput: postEditProjectController
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
                visible: postEditProjectController
                    .shouldShowField("ROOMCONFIGURATION"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.roomConfigurationInBhk,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Obx(() => CommonTextField(
                          keyboardType: TextInputType.phone,
                          controller: postEditProjectController
                              .projectRoomConfigurationController,
                          focusNode: postEditProjectController
                              .projectRoomConfigurationFocusNode,
                          hasFocus: postEditProjectController
                              .hasProjectRoomConfigurationFocus.value,
                          hasInput: postEditProjectController
                              .hasProjectRoomConfigurationInput.value,
                          hintText: AppString.enterBhk,
                          labelText: AppString.enterBhk,
                        )).paddingOnly(top: AppSize.appSize10),
                  ],
                ).paddingOnly(top: AppSize.appSize25),
              ),
            ),
            Obx(() => Visibility(
                visible: postEditProjectController
                    .shouldShowField("AMENITIESCOMMERCIAL"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.commonAmenities,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor)),
                    Obx(() {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 1,
                        children: postEditProjectController
                            .commercialAmenities.keys
                            .map((amenity) {
                          return Container(
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: postEditProjectController
                                      .selectedCommercialAmenitiesValues
                                      .contains(postEditProjectController
                                          .commercialAmenities[amenity]),
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    postEditProjectController
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
                visible: postEditProjectController
                    .shouldShowField("AMENITIESRESIDENTIAL"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.commonAmenities,
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor)),
                    Obx(() {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 1,
                        children: postEditProjectController
                            .residentialAmenities.keys
                            .map((amenity) {
                          return Container(
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: postEditProjectController
                                      .selectedResidentialAmenitiesValues
                                      .contains(postEditProjectController
                                          .residentialAmenities[amenity]),
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    postEditProjectController
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
                    style: AppStyle.heading4Medium(color: AppColor.textColor)),
                TextField(
                  controller:
                      postEditProjectController.projectDescriptionController,
                  focusNode:
                      postEditProjectController.projectDescriptionFocusNode,
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
                visible: postEditProjectController.shouldShowField("Next"),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CommonButton(
                    onPressed: () async {
                      await postEditProjectController.submitEditDetailStep1();
                      if (postEditProjectController.isProjectDetailSubmitted) {
                        postEditProjectController.projectCurrentStep.value = 2;
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
    });
  }

  Widget buildProjectSectionStep2(BuildContext context) {
    return GetBuilder<ProjectPostEditProjectController>(
        builder: (projectPostProjectControllerStep2) {
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
                        controller: projectPostProjectControllerStep2
                            .projectDeveloperNameController,
                        focusNode: projectPostProjectControllerStep2
                            .projectDeveloperNameFocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectDeveloperNameFocus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectDeveloperPhoneNumber1Controller,
                        focusNode: projectPostProjectControllerStep2
                            .projectDeveloperPhoneNumber1FocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectDeveloperPhoneNumber1Focus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectDeveloperPhoneNumber2Controller,
                        focusNode: projectPostProjectControllerStep2
                            .projectDeveloperPhoneNumber2FocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectDeveloperPhoneNumber2Focus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectDeveloperEmailAddress1Controller,
                        focusNode: projectPostProjectControllerStep2
                            .projectDeveloperEmailAddress1FocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectDeveloperEmailAddress1Focus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectDeveloperEmailAddress2Controller,
                        focusNode: projectPostProjectControllerStep2
                            .projectDeveloperEmailAddress2FocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectDeveloperEmailAddress2Focus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectContactPersonNameController,
                        focusNode: projectPostProjectControllerStep2
                            .projectContactPersonNameFocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectContactPersonNameFocus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectContactPersonPhoneNumberController,
                        focusNode: projectPostProjectControllerStep2
                            .projectContactPersonPhoneNumberFocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectContactPersonPhoneNumberFocus.value,
                        hasInput: projectPostProjectControllerStep2
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
                        controller: projectPostProjectControllerStep2
                            .projectContactPersonEmailController,
                        focusNode: projectPostProjectControllerStep2
                            .projectContactPersonEmailFocusNode,
                        hasFocus: projectPostProjectControllerStep2
                            .hasProjectContactPersonEmailFocus.value,
                        hasInput: projectPostProjectControllerStep2
                            .hasProjectContactPersonEmailInput.value,
                        hintText: AppString.enterContactPersonEmail,
                        labelText: AppString.enterContactPersonEmail,
                      )).paddingOnly(top: AppSize.appSize10),
                ],
              ).paddingOnly(top: AppSize.appSize10),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CommonButton(
                  onPressed: () async {
                    await projectPostProjectControllerStep2
                        .submitEditProjectDetailsStep2();
                    if (projectPostProjectControllerStep2
                        .isProjectDetailSubmittedStep2) {
                      projectPostProjectControllerStep2
                          .projectCurrentStep.value = 3;
                      projectPostProjectControllerStep2.update();
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
                    top: AppSize.appSize10),
              )
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
                      controller: postEditProjectController
                          .projectTokenAmountController,
                      focusNode:
                          postEditProjectController.projectTokenAmountFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectTokenAmountFocus.value,
                      hasInput: postEditProjectController
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
                      controller: postEditProjectController
                          .projectPropertyTaxController,
                      focusNode:
                          postEditProjectController.projectPropertyTaxFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectPropertyTaxFocus.value,
                      hasInput: postEditProjectController
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
                      controller: postEditProjectController
                          .projectMaintenanceFeeController,
                      focusNode: postEditProjectController
                          .projectMaintenanceFeeFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectMaintenanceFeeFocus.value,
                      hasInput: postEditProjectController
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
                      controller: postEditProjectController
                          .projectAdditionalFeeController,
                      focusNode: postEditProjectController
                          .projectAdditionalFeeFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectAdditionalFeeFocus.value,
                      hasInput: postEditProjectController
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
                      controller:
                          postEditProjectController.projectPriceRangeController,
                      focusNode:
                          postEditProjectController.projectPriceRangeFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectPriceRangeFocus.value,
                      hasInput: postEditProjectController
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
                      controller: postEditProjectController
                          .projectOccupancyRateController,
                      focusNode: postEditProjectController
                          .projectOccupancyRateFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectOccupancyRateFocus.value,
                      hasInput: postEditProjectController
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
                      controller: postEditProjectController
                          .projectAnnualRentalIncomeController,
                      focusNode: postEditProjectController
                          .projectAnnualRentalIncomeFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectAnnualRentalIncomeFocus.value,
                      hasInput: postEditProjectController
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
                      controller: postEditProjectController
                          .projectCurrentValuationController,
                      focusNode: postEditProjectController
                          .projectCurrentValuationFocusNode,
                      hasFocus: postEditProjectController
                          .hasProjectCurrentValuationFocus.value,
                      hasInput: postEditProjectController
                          .hasProjectCurrentValuationInput.value,
                      hintText: AppString.enterCurrentValuation,
                      labelText: AppString.enterCurrentValuation,
                    )).paddingOnly(top: AppSize.appSize10),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CommonButton(
                    onPressed: () async {
                      await postEditProjectController
                          .submitEditProjectDetailsStep3();
                      if (postEditProjectController
                          .isProjectDetailSubmittedStep3) {
                        postEditProjectController.projectCurrentStep.value = 4;
                        postEditProjectController.update();
                      }
                      ;
                    },
                    child: Text(
                      AppString.nextButton,
                      style:
                          AppStyle.heading5Medium(color: AppColor.whiteColor),
                    ),
                  ).paddingOnly(
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                    bottom: AppSize.appSize26,
                    top: AppSize.appSize25,
                  ),
                )
              ],
            ).paddingOnly(top: AppSize.appSize25),
          ],
        ),
      );
    });
  }

  List<File> selectedImages = [];

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
                          await postEditProjectController
                              .submitEditProjectDetailsStep4Images(
                                  selectedImages);
                          if (postEditProjectController
                              .isProjectDetailSubmittedStep4) {
                            Get.find<HomeController>()
                                .fetchPostProjectListing();
                            Get.find<HomeController>().fetchPostPropertyList();
                            Get.offNamed(AppRoutes.bottomBarView);
                          }
                        },
                        backgroundColor: AppColor.primaryColor,
                        child: postEditProjectController.isLoadingStep4.value
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

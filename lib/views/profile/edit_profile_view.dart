import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../api_service/app_config.dart';
import '../../api_service/print_logger.dart';
import '../../common/common_button.dart';
import '../../common/common_textfield.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/edit_country_picker_controller.dart';
import '../../controller/edit_profile_controller.dart';
import '../../controller/profile_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/city_model.dart';
import '../../model/state_model.dart';
import '../../routes/app_routes.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final ProfileController profileController = Get.find<ProfileController>();

  final EditProfileController editProfileController =
      Get.find<EditProfileController>();
  EditCountryPickerController editCountryPickerController =
      Get.put(EditCountryPickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildEditProfileFields(context),
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
        AppString.editProfile,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildEditProfileFields(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: AppColor.whiteColor,
              radius: AppSize.appSize62,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() {
                    final selectedImage =
                        editProfileController.profileImage.value;
                    final webImage = editProfileController.webImage.value;
                    final networkImage = profileController.user.value?.image;
                    if (selectedImage.isNotEmpty) {
                      return CircleAvatar(
                        radius: AppSize.appSize50,
                        backgroundColor: AppColor.whiteColor,
                        backgroundImage: FileImage(
                          File(selectedImage),
                        ),
                      );
                    } else if (webImage != null) {
                      return CircleAvatar(
                        radius: AppSize.appSize50,
                        backgroundColor: AppColor.whiteColor,
                        backgroundImage: MemoryImage(webImage),
                      );
                    } else if (networkImage != null &&
                        networkImage.isNotEmpty) {
                      return CircleAvatar(
                        radius: AppSize.appSize50,
                        backgroundColor: AppColor.whiteColor,
                        backgroundImage: NetworkImage(
                          "${AppConfigs.mediaUrl}$networkImage?path=Profile",
                        ),
                      );
                    } else {
                      return const CircleAvatar(
                        backgroundColor: AppColor.whiteColor,
                        backgroundImage: AssetImage(
                          "assets/myImg/unknown_user.png",
                        ),
                        radius: AppSize.appSize50,
                      );
                    }
                  }),
                  Positioned(
                    bottom: AppSize.appSize2,
                    right: AppSize.appSize2,
                    child: GestureDetector(
                      onTap: () {
                        editProfileController.updateProfileImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColor.whiteColor,
                        backgroundImage: AssetImage(
                          Assets.images.editImage.path,
                        ),
                        radius: AppSize.appSize15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
            height: AppSize.appSize0,
            thickness: AppSize.appSize2,
          ).paddingOnly(top: AppSize.appSize20, bottom: AppSize.appSize10),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Email",
                        style:
                            AppStyle.heading5Medium(color: AppColor.textColor),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Obx(
                        () => Text(
                          profileController.user.value?.email ?? "",
                          //"testing email.com",
                          style: AppStyle.heading3Medium(
                              color: AppColor.textColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Phone Number",
                        style:
                            AppStyle.heading5Medium(color: AppColor.textColor),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Obx(
                      () => Text(
                        profileController.user.value?.phone ?? "",
                        //"testing email.com",
                        style:
                            AppStyle.heading3Medium(color: AppColor.textColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CommonButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.updateCredentialsView);
                    },
                    child: Text(
                      "Update Credentials",
                      style:
                          AppStyle.heading5Medium(color: AppColor.whiteColor),
                    ),
                  ),
                )
              ],
            ),
          ),

          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
            height: AppSize.appSize0,
            thickness: AppSize.appSize2,
          ).paddingOnly(
            top: AppSize.appSize20,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.fullName,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              Obx(() => CommonTextField(
                    controller: editProfileController.fullNameController,
                    focusNode: editProfileController.fullNameFocusNode,
                    hasFocus: editProfileController.hasFullNameFocus.value,
                    hasInput: editProfileController.hasFullNameInput.value,
                    hintText: AppString.fullName,
                    labelText: AppString.fullName,
                  )),
            ],
          ).paddingOnly(top: AppSize.appSize30),
          // Obx(() => Container(
          //   padding:  EdgeInsets.only(
          //     top: editProfileController.hasPhoneNumberFocus.value || editProfileController.hasPhoneNumberInput.value
          //         ? AppSize.appSize6 : AppSize.appSize14,
          //     bottom: editProfileController.hasPhoneNumberFocus.value || editProfileController.hasPhoneNumberInput.value
          //         ? AppSize.appSize8 : AppSize.appSize14,
          //     left: editProfileController.hasPhoneNumberFocus.value
          //         ? AppSize.appSize0 : AppSize.appSize16,
          //   ),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //     border: Border.all(
          //       color: editProfileController.hasPhoneNumberFocus.value || editProfileController.hasPhoneNumberInput.value
          //           ? AppColor.primaryColor
          //           : AppColor.descriptionColor,
          //       // width: AppSize.appSizePoint7,
          //     ),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       editProfileController.hasPhoneNumberFocus.value || editProfileController.hasPhoneNumberInput.value
          //           ? Text(
          //         AppString.phoneNumber,
          //         style: AppStyle.heading6Regular(color: AppColor.primaryColor),
          //       ).paddingOnly(
          //         left: editProfileController.hasPhoneNumberInput.value
          //             ? (editProfileController.hasPhoneNumberFocus.value
          //             ? AppSize.appSize16 : AppSize.appSize0)
          //             : AppSize.appSize16,
          //         bottom: editProfileController.hasPhoneNumberInput.value
          //             ? AppSize.appSize2 : AppSize.appSize2,
          //       ) : const SizedBox.shrink(),
          //       Row(
          //         children: [
          //           editProfileController.hasPhoneNumberFocus.value || editProfileController.hasPhoneNumberInput.value ? SizedBox(
          //             // width: AppSize.appSize78,
          //             child: IntrinsicHeight(
          //               child: GestureDetector(
          //                 onTap: () {
          //                   editCountryPickerBottomSheet(context);
          //                 },
          //                 child: Row(
          //                   children: [
          //                     Obx(() {
          //                       final selectedCountryIndex =
          //                           editCountryPickerController.selectedIndex.value;
          //                       return Text(
          //                         editCountryPickerController.countries[selectedCountryIndex]
          //                         [AppString.codeText] ?? '',
          //                         style: AppStyle.heading4Regular(color: AppColor.primaryColor),
          //                       );
          //                     }),
          //                     Image.asset(
          //                       Assets.images.dropdown.path,
          //                       width: AppSize.appSize16,
          //                     ).paddingOnly(left: AppSize.appSize8, right: AppSize.appSize3),
          //                     const VerticalDivider(
          //                       color: AppColor.primaryColor,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ).paddingOnly(
          //             left: editProfileController.hasPhoneNumberInput.value
          //                 ? (editProfileController.hasPhoneNumberFocus.value
          //                 ? AppSize.appSize16 : AppSize.appSize0)
          //                 : AppSize.appSize16,
          //           ) : const SizedBox.shrink(),
          //           Expanded(
          //             child: SizedBox(
          //               height: AppSize.appSize27,
          //               width: double.infinity,
          //               child: TextFormField(
          //                 focusNode: editProfileController.phoneNumberFocusNode,
          //                 controller: editProfileController.phoneNumberController,
          //                 cursorColor: AppColor.primaryColor,
          //                 keyboardType: TextInputType.phone,
          //                 style: AppStyle.heading4Regular(color: AppColor.textColor),
          //                 inputFormatters: [
          //                   LengthLimitingTextInputFormatter(AppSize.size10),
          //                 ],
          //                 decoration: InputDecoration(
          //                   contentPadding: const EdgeInsets.symmetric(
          //                     horizontal: AppSize.appSize0, vertical: AppSize.appSize0,
          //                   ),
          //                   isDense: true,
          //                   hintText: editProfileController.hasPhoneNumberFocus.value ? '' : AppString.phoneNumber,
          //                   hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
          //                   border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // )).paddingOnly(top: AppSize.appSize16),
          // Obx(() => Container(
          //   padding:  EdgeInsets.only(
          //     top: editProfileController.hasPhoneNumber2Focus.value || editProfileController.hasPhoneNumber2Input.value
          //         ? AppSize.appSize6 : AppSize.appSize14,
          //     bottom: editProfileController.hasPhoneNumber2Focus.value || editProfileController.hasPhoneNumber2Input.value
          //         ? AppSize.appSize8 : AppSize.appSize14,
          //     left: editProfileController.hasPhoneNumber2Focus.value
          //         ? AppSize.appSize0 : AppSize.appSize16,
          //   ),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //     border: Border.all(
          //       color: editProfileController.hasPhoneNumber2Focus.value || editProfileController.hasPhoneNumber2Input.value
          //           ? AppColor.primaryColor
          //           : AppColor.descriptionColor,
          //       // width: AppSize.appSizePoint7,
          //     ),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       editProfileController.hasPhoneNumber2Focus.value || editProfileController.hasPhoneNumber2Input.value
          //           ? Text(
          //         AppString.phoneNumber,
          //         style: AppStyle.heading6Regular(color: AppColor.primaryColor),
          //       ).paddingOnly(
          //         left: editProfileController.hasPhoneNumber2Input.value
          //             ? (editProfileController.hasPhoneNumber2Focus.value
          //             ? AppSize.appSize16 : AppSize.appSize0)
          //             : AppSize.appSize16,
          //         bottom: editProfileController.hasPhoneNumber2Input.value
          //             ? AppSize.appSize2 : AppSize.appSize2,
          //       ) : const SizedBox.shrink(),
          //       Row(
          //         children: [
          //           editProfileController.hasPhoneNumber2Focus.value || editProfileController.hasPhoneNumber2Input.value ? SizedBox(
          //             // width: AppSize.appSize78,
          //             child: IntrinsicHeight(
          //               child: GestureDetector(
          //                 onTap: () {
          //                   editSecondCountryPickerBottomSheet(context);
          //                 },
          //                 child: Row(
          //                   children: [
          //                     Obx(() {
          //                       final selectedCountryIndex =
          //                           editCountryPickerController.selected2Index.value;
          //                       return Text(
          //                         editCountryPickerController.countries[selectedCountryIndex]
          //                         [AppString.codeText] ?? '',
          //                         style: AppStyle.heading4Regular(color: AppColor.primaryColor),
          //                       );
          //                     }),
          //                     Image.asset(
          //                       Assets.images.dropdown.path,
          //                       width: AppSize.appSize16,
          //                     ).paddingOnly(left: AppSize.appSize8, right: AppSize.appSize3),
          //                     const VerticalDivider(
          //                       color: AppColor.primaryColor,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ).paddingOnly(
          //             left: editProfileController.hasPhoneNumber2Input.value
          //                 ? (editProfileController.hasPhoneNumber2Focus.value
          //                 ? AppSize.appSize16 : AppSize.appSize0)
          //                 : AppSize.appSize16,
          //           ) : const SizedBox.shrink(),
          //           Expanded(
          //             child: SizedBox(
          //               height: AppSize.appSize27,
          //               width: double.infinity,
          //               child: TextFormField(
          //                 focusNode: editProfileController.phoneNumber2FocusNode,
          //                 controller: editProfileController.phoneNumber2Controller,
          //                 cursorColor: AppColor.primaryColor,
          //                 keyboardType: TextInputType.phone,
          //                 style: AppStyle.heading4Regular(color: AppColor.textColor),
          //                 inputFormatters: [
          //                   LengthLimitingTextInputFormatter(AppSize.size10),
          //                 ],
          //                 decoration: InputDecoration(
          //                   contentPadding: const EdgeInsets.symmetric(
          //                     horizontal: AppSize.appSize0, vertical: AppSize.appSize0,
          //                   ),
          //                   isDense: true,
          //                   hintText: editProfileController.hasPhoneNumber2Focus.value ? '' : AppString.phoneNumber2,
          //                   hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
          //                   border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // )).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.alternate,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              Obx(() => CommonTextField(
                    controller: editProfileController.alternateNumberController,
                    focusNode: editProfileController.alternateNumberFocusNode,
                    hasFocus:
                        editProfileController.hasAlternateNumberFocus.value,
                    hasInput:
                        editProfileController.hasAlternateNumberInput.value,
                    hintText: "Enter alternate number",
                    labelText: "Alternate Number",
                    keyboardType: TextInputType.phone,
                  )),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.dealsOn,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              Obx(() => CommonTextField(
                    controller: editProfileController.dealsOnController,
                    focusNode: editProfileController.dealsOnFocusNode,
                    hasFocus: editProfileController.hasDealsOnFocus.value,
                    hasInput: editProfileController.hasDealsOnInput.value,
                    hintText: "Enter your deals category",
                    labelText: "Deals On",
                  )),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.officeName,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              Obx(() => CommonTextField(
                    controller: editProfileController.officeNameController,
                    focusNode: editProfileController.officeNameFocusNode,
                    hasFocus: editProfileController.hasOfficeNameFocus.value,
                    hasInput: editProfileController.hasOfficeNameInput.value,
                    hintText: "Enter office name",
                    labelText: "Office Name",
                  )),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.country,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              Obx(() => CommonTextField(
                    controller: editProfileController.countryController,
                    focusNode: editProfileController.countryFocusNode,
                    hasFocus: editProfileController.hasCountryFocus.value,
                    hasInput: editProfileController.hasCountryInput.value,
                    hintText: "India",
                    labelText: "Country",
                    readOnly: true,
                  )),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.state,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                top: 10,
                bottom: AppSize.appSize10,
                left: AppSize.appSize10,
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TypeAheadField<AppState>(
                    key: const ValueKey("state_list"),
                    controller: editProfileController.stateSearchController,
                    builder: (context, stateSearchController, focusNode) {
                      return TextField(
                        controller: stateSearchController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: "Type to search state...",
                          hintStyle:
                              TextStyle(color: AppColor.descriptionColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                      );
                    },
                    suggestionsCallback: (String pattern) async {
                      return editProfileController.stateOptions
                          .where((state) => state.name
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, AppState suggestion) {
                      return ListTile(
                        title: Text(suggestion.name),
                      );
                    },
                    onSelected: (AppState selectedAppState) {
                      editProfileController.selectedState = selectedAppState;
                      editProfileController.stateSearchController.text =
                          selectedAppState.name;

                      AppLogger.log(
                          "Selected State -->> ${selectedAppState.name}");
                      // editProfileController.clearSelectedStateCity();
                      editProfileController.cityOptions.clear();
                      editProfileController.citySearchController.clear();
                      editProfileController.selectedCity = null;

                      editProfileController.fetchCityList(selectedAppState.id);
                      editProfileController.update();
                    },
                  )),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.city,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GetBuilder<EditProfileController>(
                    id: 'city_field',
                    builder: (editProfileController) {
                      return TypeAheadField<City>(
                        key: ValueKey(
                            "city_state_${editProfileController.selectedState?.id ?? 'none'}"),
                        controller: editProfileController.citySearchController,
                        builder: (context, citySearchController, focusNode) {
                          return TextField(
                            controller: citySearchController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: "Type to search Area...",
                              hintStyle:
                                  TextStyle(color: AppColor.descriptionColor),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                            ),
                          );
                        },
                        suggestionsCallback: (String pattern) {
                          return editProfileController.cityOptions
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
                          editProfileController.selectedCity = selectedCity;
                          editProfileController.citySearchController.text =
                              selectedCity.name;
                          editProfileController.update();
                        },
                      );
                    }),
              )
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.area,
                            style: AppStyle.heading3Medium(
                                color: AppColor.textColor))
                        .paddingOnly(
                            top: AppSize.appSize10,
                            left: AppSize.appSize10,
                            bottom: AppSize.appSize10),
                    Obx(() => CommonTextField(
                          controller: editProfileController.areaController,
                          focusNode: editProfileController.areaFocusNode,
                          hasFocus: editProfileController.hasAreaFocus.value,
                          hasInput: editProfileController.hasAreaInput.value,
                          hintText: "Enter your area",
                          labelText: "Area",
                        )),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.pinCode,
                            style: AppStyle.heading3Medium(
                                color: AppColor.textColor))
                        .paddingOnly(
                            top: AppSize.appSize10,
                            left: AppSize.appSize10,
                            bottom: AppSize.appSize10),
                    Obx(() => CommonTextField(
                          controller: editProfileController.zipController,
                          focusNode: editProfileController.zipFocusNode,
                          hasFocus: editProfileController.hasZipFocus.value,
                          hasInput: editProfileController.hasZipInput.value,
                          hintText: "Enter your Pin Code",
                          labelText: "Pin COde",
                        )),
                  ],
                ),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.aboutMe,
                      style: AppStyle.heading3Medium(color: AppColor.textColor))
                  .paddingOnly(
                      top: AppSize.appSize10,
                      left: AppSize.appSize10,
                      bottom: AppSize.appSize10),
              TextFormField(
                controller: editProfileController.aboutMeController,
                cursorColor: AppColor.primaryColor,
                style: AppStyle.heading4Regular(color: AppColor.textColor),
                maxLines: AppSize.size3,
                decoration: InputDecoration(
                  hintText: AppString.aboutMe,
                  hintStyle: AppStyle.heading4Regular(
                      color: AppColor.descriptionColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                    borderSide: BorderSide(
                      color: AppColor.descriptionColor
                          .withOpacity(AppSize.appSizePoint7),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                    borderSide: BorderSide(
                      color: AppColor.descriptionColor
                          .withOpacity(AppSize.appSizePoint7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                    borderSide: const BorderSide(
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize16),

          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gender",
                      style:
                          AppStyle.heading5Medium(color: AppColor.textColor)),
                  Row(
                    children: [1, 2, 4].map((index) {
                      String label = index == 1
                          ? "Male"
                          : index == 2
                              ? "Female"
                              : "Other";
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              editProfileController.selectedGender(index),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue:
                                    editProfileController.selectedGender.value,
                                onChanged: (value) => editProfileController
                                    .selectedGender(value!),
                                activeColor: AppColor.primaryColor,
                              ),
                              Text(label,
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )).paddingOnly(top: AppSize.appSize16),

          // Obx(() => TextFormField(
          //   controller: editProfileController.whatAreYouHereController,
          //   cursorColor: AppColor.primaryColor,
          //   style: AppStyle.heading4Regular(color: AppColor.textColor),
          //   readOnly: true,
          //   onTap: () {
          //     editProfileController.toggleWhatAreYouHereExpansion();
          //   },
          //   decoration: InputDecoration(
          //     hintText: AppString.whatAreYouHere,
          //     hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(AppSize.appSize12),
          //       borderSide: BorderSide(
          //         color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(AppSize.appSize12),
          //       borderSide: BorderSide(
          //         color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(AppSize.appSize12),
          //       borderSide: const BorderSide(
          //         color: AppColor.primaryColor,
          //       ),
          //     ),
          //     suffixIcon: Image.asset(
          //       editProfileController.isWhatAreYouHereExpanded.value
          //           ? Assets.images.dropdownExpand.path
          //           : Assets.images.dropdown.path,
          //     ).paddingOnly(right: AppSize.appSize16),
          //     suffixIconConstraints: const BoxConstraints(
          //       maxWidth: AppSize.appSize34,
          //     ),
          //   ),
          // )).paddingOnly(top: AppSize.appSize16),
          // Obx(() => AnimatedContainer(
          //   duration: const Duration(seconds: AppSize.size1),
          //   curve: Curves.fastEaseInToSlowEaseOut,
          //   margin: EdgeInsets.only(
          //     top: editProfileController.isWhatAreYouHereExpanded.value
          //         ? AppSize.appSize16
          //         : AppSize.appSize0,
          //   ),
          //   height: editProfileController.isWhatAreYouHereExpanded.value
          //       ? null
          //       : AppSize.appSize0,
          //   child: editProfileController.isWhatAreYouHereExpanded.value
          //       ? GestureDetector(
          //     onTap: () {
          //       // editProfileController.toggleWhatAreYouHereExpansion();
          //     },
          //     child: Container(
          //       padding: const EdgeInsets.only(
          //         left: AppSize.appSize16,
          //         right: AppSize.appSize16,
          //         top: AppSize.appSize16,
          //         bottom: AppSize.appSize6,
          //       ),
          //       decoration: BoxDecoration(
          //         borderRadius:
          //         BorderRadius.circular(AppSize.appSize12),
          //         color: AppColor.whiteColor,
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Colors.black12,
          //             spreadRadius: AppSize.appSizePoint1,
          //             blurRadius: AppSize.appSize2,
          //           ),
          //         ],
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: List.generate(editProfileController.whatAreYouHereList.length, (index) {
          //           return GestureDetector(
          //             onTap: () {
          //               editProfileController.updateWhatAreYouHere(index);
          //               editProfileController.toggleWhatAreYouHereExpansion();
          //             },
          //             child: Row(
          //               children: [
          //                 Container(
          //                   width: AppSize.appSize20,
          //                   height: AppSize.appSize20,
          //                   decoration: BoxDecoration(
          //                     border: Border.all(
          //                       color: AppColor.textColor,
          //                     ),
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: editProfileController.isWhatAreYouHereSelect.value == index ? Center(
          //                     child: Container(
          //                       width: AppSize.appSize12,
          //                       height: AppSize.appSize12,
          //                       decoration: const BoxDecoration(
          //                         color: AppColor.textColor,
          //                         shape: BoxShape.circle,
          //                       ),
          //                     ),
          //                   ) : const SizedBox.shrink(),
          //                 ),
          //                 Text(
          //                   editProfileController.whatAreYouHereList[index],
          //                   style: AppStyle.heading5Regular(color: AppColor.textColor),
          //                 ).paddingOnly(left: AppSize.appSize10),
          //               ],
          //             ).paddingOnly(bottom: AppSize.appSize16),
          //           );
          //         }),
          //       ),
          //     ),
          //   ) : const SizedBox.shrink(),
          // )),
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
          editProfileController.updateProfile();
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          AppString.updateProfileButton,
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

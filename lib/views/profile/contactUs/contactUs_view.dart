import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common_button.dart';
import '../../../common/common_textfield.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/contactUs_controller.dart';
import '../../../gen/assets.gen.dart';

class ContactUsView extends StatelessWidget {
  ContactUsView({super.key});

  final ContactUsController contactUsController = Get.find<
      ContactUsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildFeedbackFields(context),
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
        AppString.contactUs,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildFeedbackFields(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        children: [
          Obx(() =>
              CommonTextField(
                controller: contactUsController.fullNameController,
                focusNode: contactUsController.focusNode,
                hasFocus: contactUsController.hasFullNameFocus.value,
                hasInput: contactUsController.hasFullNameInput.value,
                hintText: AppString.fullName,
                labelText: AppString.fullName,
              )).paddingOnly(top: AppSize.appSize16),
          Obx(() =>
              CommonTextField(
                controller: contactUsController.phoneNumberController,
                focusNode: contactUsController.phoneNumberFocusNode,
                hasFocus: contactUsController.hasPhoneNumberFocus.value,
                hasInput: contactUsController.hasPhoneNumberInput.value,
                hintText: AppString.phone,
                labelText: AppString.phone,
                keyboardType: TextInputType.phone,
              )).paddingOnly(top: AppSize.appSize16),
          Obx(() =>
              CommonTextField(
                controller: contactUsController.emailController,
                focusNode: contactUsController.emailFocusNode,
                hasFocus: contactUsController.hasEmailFocus.value,
                hasInput: contactUsController.hasEmailInput.value,
                hintText: AppString.emailAddress,
                labelText: AppString.emailAddress,
                keyboardType: TextInputType.emailAddress,
              )).paddingOnly(top: AppSize.appSize16),

          TextFormField(
            controller: contactUsController.messageController,
            cursorColor: AppColor.primaryColor,
            style: AppStyle.heading4Regular(color: AppColor.textColor),
            maxLines: AppSize.size3,
            decoration: InputDecoration(
              hintText: AppString.typeYourQueryHere,
              hintStyle: AppStyle.heading4Regular(
                  color: AppColor.descriptionColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: BorderSide(
                  color: AppColor.descriptionColor.withOpacity(
                      AppSize.appSizePoint7),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: BorderSide(
                  color: AppColor.descriptionColor.withOpacity(
                      AppSize.appSizePoint7),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: const BorderSide(
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ).paddingOnly(top: AppSize.appSize16),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16, right: AppSize.appSize16,
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
      ),
      child: CommonButton(
        onPressed:
        contactUsController.isLoading.value
            ? null
            : () {
          contactUsController.contactUs();
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          AppString.submitButton,
          style: AppStyle.heading5Medium(color: AppColor.whiteColor),
        ),
      ).paddingOnly(
        left: AppSize.appSize16, right: AppSize.appSize16,
        bottom: AppSize.appSize26, top: AppSize.appSize10,
      ),
    );
  }
}

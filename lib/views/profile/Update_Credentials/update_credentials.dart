import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common_button.dart';
import '../../../common/common_textfield.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_size.dart';
import '../../../configs/app_string.dart';
import '../../../configs/app_style.dart';
import '../../../controller/update_credentials_controller.dart';
import '../../../gen/assets.gen.dart';

class UpdateCredentials extends StatelessWidget {
  UpdateCredentials({super.key});

  UpdateCredentialsController updateCredentialsController =
      Get.find<UpdateCredentialsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildEditCredentialsFields(context),
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
        AppString.editCredentials,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildEditCredentialsFields(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone Number :",
                style: AppStyle.heading5Medium(color: AppColor.black),
              )),
          Obx(() => CommonTextField(
                controller: updateCredentialsController.phoneNumberController,
                focusNode: updateCredentialsController.phoneNumberFocusNode,
                hasFocus: updateCredentialsController.hasPhoneNumberFocus.value,
                hasInput: updateCredentialsController.hasPhoneNumberInput.value,
                hintText: "Enter phone number to update",
                labelText: "Enter phone number to update",
                keyboardType: TextInputType.phone,
              )).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize16),
          const SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email Address :",
                style: AppStyle.heading5Medium(color: AppColor.black),
              )),
          Obx(() => CommonTextField(
                controller: updateCredentialsController.emailController,
                focusNode: updateCredentialsController.emailFocusNode,
                hasFocus: updateCredentialsController.hasEmailFocus.value,
                hasInput: updateCredentialsController.hasEmailInput.value,
                hintText: "Enter email to update",
                labelText: "Enter email to update",
              )).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize16),
          const SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password :",
                style: AppStyle.heading5Medium(color: AppColor.black),
              )),
          Obx(() => CommonTextField(
                controller: updateCredentialsController.passwordController,
                focusNode: updateCredentialsController.passwordFocusNode,
                hasFocus: updateCredentialsController.hasPasswordFocus.value,
                hasInput: updateCredentialsController.hasPasswordInput.value,
                hintText: "Enter password to Update",
                labelText: "Enter password to update",
              )).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize16),
          const SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm Password :",
                style: AppStyle.heading5Medium(color: AppColor.black),
              )),
          Obx(() => CommonTextField(
                controller:
                    updateCredentialsController.confirmPasswordController,
                focusNode: updateCredentialsController.confirmPasswordFocusNode,
                hasFocus:
                    updateCredentialsController.hasConfirmPasswordFocus.value,
                hasInput:
                    updateCredentialsController.hasConfirmPasswordInput.value,
                hintText: "Confirm Password",
                labelText: "Confirm Password",
              )).paddingOnly(top: AppSize.appSize6, bottom: AppSize.appSize16),
        ],
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
          updateCredentialsController.updateCredentials();
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          AppString.updateCredentialsButton,
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

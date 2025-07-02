import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../common/common_textfield.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/contact_developer_controller.dart';
import '../../gen/assets.gen.dart';

class ContactDeveloperView extends StatelessWidget {
  ContactDeveloperView({super.key});

  final ContactDeveloperController contactDeveloperController =
      Get.find<ContactDeveloperController>();

  String maskPhoneNumber(String phone) {
    if (phone.length < 4) {
      return "XXXX";
    }
    return "${phone.substring(0, 2)}XXXXXX${phone.substring(phone.length - 2)}";
  }

  String maskEmail(String email) {
    email = email.toLowerCase();
    List<String> parts = email.split("@");
    if (parts.length != 2) return "Invalid Email";

    String username = parts[0];
    String domain = parts[1];

    if (username.length <= 2) {
      return "${username[0]}X@$domain";
    }

    int maskLength = username.length - 2;
    String maskedPart = "X" * maskLength;

    return "${username[0]}$maskedPart${username[username.length - 1]}@$domain";
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments;
    final String name = arguments?["name"] ?? "Unknown";
    final String phone = arguments?["phone"] ?? "XXXXXX";
    final String phone2 = arguments?["phone2"] ?? "XXXXXX";
    final String email = arguments?["email"] ?? "XXXXXX";
    final String email2 = arguments?["email2"] ?? "XXXXXX";
    final int projectId = arguments?["projectId"] as int;

    // AppLogger.log(" Name -->>$name, Phone -->>$phone, Email -->>$email, Email2-->>$email2, phone2 ->>>$phone2");

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildContactDeveloper(
        name,
        phone,
        phone2,
        email,
        email2,
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
        "Developer Details",
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildButton(
      String buttonText, VoidCallback onPressed, RxBool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.appSize16, vertical: AppSize.appSize16),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
            onPressed: isLoading.value ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(
                  vertical: AppSize.appSize14, horizontal: AppSize.appSize14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
              ),
            ),
            child: isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    buttonText,
                    style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                  )),
      ),
    );
  }

  Widget buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(AppSize.appSize10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        border: Border.all(
          color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
          width: AppSize.appSizePoint7,
        ),
      ),
      child: Column(
        children: [
          Obx(() => CommonTextField(
                controller: contactDeveloperController.fullNameController,
                focusNode: contactDeveloperController.focusNode,
                hasFocus: contactDeveloperController.hasFullNameFocus.value,
                hasInput: contactDeveloperController.hasFullNameInput.value,
                hintText: AppString.fullName,
                labelText: AppString.fullName,
              )).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Obx(() => CommonTextField(
                controller: contactDeveloperController.mobileNumberController,
                focusNode: contactDeveloperController.phoneNumberFocusNode,
                hasFocus: contactDeveloperController.hasPhoneNumberFocus.value,
                hasInput: contactDeveloperController.hasPhoneNumberInput.value,
                hintText: AppString.phoneNumber,
                labelText: AppString.phoneNumber,
              )).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Obx(() => CommonTextField(
                controller: contactDeveloperController.emailController,
                focusNode: contactDeveloperController.emailFocusNode,
                hasFocus: contactDeveloperController.hasEmailFocus.value,
                hasInput: contactDeveloperController.hasEmailInput.value,
                hintText: AppString.emailAddress,
                labelText: AppString.emailAddress,
              )).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          buildButton("Get Phone Number", () {
            contactDeveloperController.contactDeveloper();
          }, contactDeveloperController.isContactDeveloperLoading),
        ],
      ),
    ).paddingOnly(
      top: AppSize.appSize16,
      left: AppSize.appSize16,
      right: AppSize.appSize16,
    );
  }

  Widget buildOtpForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter OTP",
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(bottom: AppSize.appSize10),
          PinCodeTextField(
            appContext: context,
            length: 4,
            controller: contactDeveloperController.otpController,
            focusNode: contactDeveloperController.otpFocusNode,
            autoFocus: true,
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            enableActiveFill: true,
            onChanged: (value) {
              contactDeveloperController.hasOtpInput.value = value.length == 4;
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 60,
              fieldWidth: 50,
              activeColor: AppColor.primaryColor,
              selectedColor: AppColor.primaryColor.withOpacity(0.6),
              inactiveColor: AppColor.black,
              activeFillColor: AppColor.whiteColor,
              selectedFillColor: AppColor.whiteColor,
              inactiveFillColor: AppColor.whiteColor,
            ),
          ),
          Center(
            child: buildButton("Verify OTP", () {
              contactDeveloperController.verifyOtp();
            }, contactDeveloperController.isVerifyOtpLoading),
          ),
        ],
      ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
    );
  }

  Widget buildContactDeveloper(
      String name, String phone, String phone2, String email, String email2) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSize.appSize10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              border: Border.all(
                color: AppColor.descriptionColor
                    .withOpacity(AppSize.appSizePoint4),
                width: AppSize.appSizePoint7,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSize.appSize10),
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                  ),
                  child: Text(
                    name,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      Assets.images.call.path,
                      width: AppSize.appSize20,
                      color: AppColor.primaryColor,
                    ),
                    Obx(() {
                      final displayPhone =
                          contactDeveloperController.isVerified.value
                              ? phone
                              : maskPhoneNumber(phone);

                      return Text(
                        displayPhone,
                        style: AppStyle.heading5Regular(color: AppColor.black),
                      ).paddingOnly(left: AppSize.appSize10);
                    }),
                  ],
                ).paddingOnly(top: AppSize.appSize16),
                (phone2 != null &&
                        phone2.trim().isNotEmpty &&
                        phone2 != "XXXXXX")
                    ? Row(
                        children: [
                          Image.asset(
                            Assets.images.call.path,
                            width: AppSize.appSize20,
                            color: AppColor.primaryColor,
                          ),
                          Obx(() {
                            final displayPhone =
                                contactDeveloperController.isVerified.value
                                    ? phone2
                                    : maskPhoneNumber(phone2);

                            return Text(
                              displayPhone,
                              style: AppStyle.heading5Regular(
                                  color: AppColor.black),
                            ).paddingOnly(left: AppSize.appSize10);
                          }),
                        ],
                      ).paddingOnly(top: AppSize.appSize16)
                    : const SizedBox.shrink(),
                Row(
                  children: [
                    Image.asset(
                      Assets.images.email.path,
                      width: AppSize.appSize20,
                      color: AppColor.primaryColor,
                    ),
                    Obx(() {
                      final displayEmail =
                          contactDeveloperController.isVerified.value
                              ? email
                              : maskEmail(email);

                      return Text(
                        displayEmail,
                        style: AppStyle.heading5Regular(color: AppColor.black),
                      ).paddingOnly(left: AppSize.appSize10);
                    }),
                  ],
                ).paddingOnly(top: AppSize.appSize16),
                (email2 != null &&
                        email2.trim().isNotEmpty &&
                        email2 != "XXXXXX")
                    ? Row(
                        children: [
                          Image.asset(
                            Assets.images.email.path,
                            width: AppSize.appSize20,
                            color: AppColor.primaryColor,
                          ),
                          Obx(() {
                            final displayEmail =
                                contactDeveloperController.isVerified.value
                                    ? email2
                                    : maskEmail(email2);

                            return Text(
                              displayEmail,
                              style: AppStyle.heading5Regular(
                                  color: AppColor.black),
                            ).paddingOnly(left: AppSize.appSize10);
                          }),
                        ],
                      ).paddingOnly(top: AppSize.appSize16)
                    : const SizedBox.shrink(),
                Obx(() {
                  if (contactDeveloperController.isVerified.value) {
                    return const SizedBox();
                  } else {
                    return Text(
                      AppString.contactToDeveloper,
                      style:
                          AppStyle.heading3SemiBold(color: AppColor.textColor),
                    ).paddingOnly(
                      top: AppSize.appSize36,
                      left: AppSize.appSize16,
                      right: AppSize.appSize16,
                    );
                  }
                }),
                Obx(() {
                  if (contactDeveloperController.isVerified.value) {
                    return const SizedBox();
                  } else if (contactDeveloperController.isOtpStep.value) {
                    return buildOtpForm(Get.context!);
                  } else {
                    return buildContactForm();
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../common/common_button.dart';
import '../../common/common_rich_text.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/otp_controller.dart';
import '../../model/text_segment_model.dart';
import '../../routes/app_routes.dart';

class OtpView extends StatelessWidget {
  OtpView({super.key});

  OtpController otpController = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: buildOTPField(),
      bottomNavigationBar: buildTextButton(),
    );
  }

  Widget buildOTPField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.otpVerification,
          style: AppStyle.heading1(color: AppColor.textColor),
        ),
        CommonRichText(
          segments: [
            TextSegment(
              text: AppString.verifyYourMobileNumber,
              style: AppStyle.heading4Regular(color: AppColor.descriptionColor),
            ),
            TextSegment(
              text: AppString.contactNumber,
              style: AppStyle.heading4Medium(color: AppColor.primaryColor),
            ),
          ],
        ).paddingOnly(top: AppSize.appSize12),
        Pinput(
          keyboardType: TextInputType.number,
          length: AppSize.size4,
          controller: otpController.pinController,
          autofocus: true,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          defaultPinTheme: PinTheme(
            height: AppSize.appSize51,
            width: AppSize.appSize51,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.descriptionColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            textStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
          ),
          focusedPinTheme: PinTheme(
            height: AppSize.appSize51,
            width: AppSize.appSize51,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            textStyle: AppStyle.heading4Regular(color: AppColor.primaryColor),
          ),
          followingPinTheme: PinTheme(
            height: AppSize.appSize51,
            width: AppSize.appSize51,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            textStyle: AppStyle.heading4Regular(color: AppColor.primaryColor),
          ),
        ).paddingOnly(top: AppSize.appSize36),
        Center(
          child: Obx(() => CommonRichText(
            segments: [
              TextSegment(
                text: AppString.didNotReceiveTheCode,
                style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
              ),
              TextSegment(
                text: otpController.countdown.value == AppSize.size0
                    ? AppString.resendCodeButton
                    : otpController.formattedCountdown,
                style: AppStyle.heading5Medium(color: AppColor.primaryColor),
                onTap: otpController.countdown.value == AppSize.size0 ? () {
                  otpController.startCountdown();
                } : null,
              ),
            ],
          )).paddingOnly(top: AppSize.appSize12),
        ),
        CommonButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.bottomBarView);
          },
          child: Text(
            AppString.verifyButton,
            style: AppStyle.heading5Medium(color: AppColor.whiteColor),
          ),
        ).paddingOnly(top: AppSize.appSize36),
      ],
    ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16);
  }

  Widget buildTextButton() {
    return Text(
      AppString.verifyViaMissedCallButton,
      textAlign: TextAlign.center,
      style: AppStyle.heading4Regular(color: AppColor.primaryColor),
    ).paddingOnly(bottom: AppSize.appSize26);
  }
}

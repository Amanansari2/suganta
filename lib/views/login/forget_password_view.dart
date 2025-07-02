import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/common_button.dart';
import '../../common/common_textfield.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/login_controller.dart';

class ForgetPasswordView extends StatelessWidget {
   ForgetPasswordView({super.key});

LoginController controller = Get.find<LoginController>();

@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        controller.emailController.clear();
        return true;
      },
      child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: buildForgotPassword(context),
      ),
    );
  }

  
  Widget buildForgotPassword(BuildContext context){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 18,8,18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/myImg/logo.jpg",
                  width: AppSize.appSize282 ,
                  height: AppSize.appSize150,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  AppString.forgotPassword,
                  style: AppStyle.heading1(color: AppColor.textColor),
                ),
              ).paddingOnly(top: AppSize.appSize20),
          
              Text(
                AppString.email,
                style: AppStyle.heading5(color: AppColor.textColor),
              ).paddingOnly(top: AppSize.appSize30),
          
              Obx(() => CommonTextField(
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                hasFocus: controller.hasEmailFocus.value,
                hasInput: controller.hasEmailInput.value,
                hintText: AppString.enterEmail,
                labelText: AppString.enterEmail,
              )).paddingOnly(top: 10),
          
              Obx(() {
                final duration = controller.cooldownDuration.value;
                final isLoading = controller.isLoading.value;
                return Column(
                  children: [
                    CommonButton(
                      onPressed: (duration == null && !isLoading)
                         ? () =>
                        controller.forgotPassword()
                          : null,
                      child:
                      isLoading
                          ? const CircularProgressIndicator(
                        color: AppColor.whiteColor,
                      )
                          : Text(
                        "Send Reset Link",
                        style:
                        AppStyle.heading3(color: AppColor.whiteColor),
                      ),
                    ).paddingOnly(top: AppSize.appSize25,
                        right: AppSize.appSize25,
                        left: AppSize.appSize25),
                    if(duration != null)
                      Padding(
                        padding:const EdgeInsets.only(top: 10),
                        child: Text("You can request again in"" ""${duration.inMinutes.remainder(60).toString().padLeft(2,'0')}:"
                            "${duration.inSeconds.remainder(60).toString().padLeft(2,'0')} minutes",
                          style: AppStyle.heading3SemiBold(color: AppColor.red),
                        ),
                      )
          
                  ],
                );
          
              }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common_button.dart';
import '../../common/common_textfield.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/login_controller.dart';
import '../../controller/login_country_picker_controller.dart';
import '../../routes/app_routes.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  LoginController loginController = Get.find<LoginController>();
  LoginCountryPickerController loginCountryPickerController =
      Get.put(LoginCountryPickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(child: buildLoginFields(context)),
      // bottomNavigationBar: buildTextButton(),
    );
  }

  Widget buildLoginFields(BuildContext context) {

    return Stack(
      children: [

        SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 18,8,18),
              child: Column(
          
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
                      AppString.login,
                      style: AppStyle.heading1(color: AppColor.textColor),
                    ),
                  ).paddingOnly(top: AppSize.appSize18),
                ],
              ),
            ),
          
          
            Column(
              children: [
                Obx(() => CommonTextField(
                      controller: loginController.mobileController,
                      focusNode: loginController.mobileFocusNode,
                      hasFocus: loginController.hasMobileFocus.value,
                      hasInput: loginController.hasMobileInput.value,
                      hintText: AppString.phoneNumber,
                      labelText: AppString.phoneNumber,
                    )),
                Obx(() => CommonTextField(
                      controller: loginController.passwordController,
                      focusNode: loginController.passwordFocusNode,
                      hasFocus: loginController.hasPasswordFocus.value,
                      hasInput: loginController.hasPasswordInput.value,
                      hintText: AppString.password,
                      labelText: AppString.password,
                       obscureText: loginController.isPasswordHidden.value,
                       suffixIcon: IconButton(
                           onPressed:   () {
                            loginController.isPasswordHidden.value = !loginController.isPasswordHidden.value;},
                           icon: Icon(
                             loginController.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                             size: AppSize.appSize30,
                           )),
                    )).paddingOnly(top: AppSize.appSize16),
          
                const SizedBox(height: 25,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: (){
                     Get.toNamed(AppRoutes.forgotPasswordView);
                    },
                    child: const Text("Forgot Password", style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColor.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),),
                  ),
                ),
                CommonButton(
                  onPressed: () {
                    if(loginController.isLoading.value)return;
                    loginController.loginUser();
                  },
                  child: Obx( ()=> loginController.isLoading.value
                      ? const CircularProgressIndicator(
                          color: AppColor.whiteColor,
                        )
                      : Text(
                          AppString.continueButton,
                          style:
                              AppStyle.heading3SemiBold(color: AppColor.whiteColor),
          
                        ),
                )
          
                ).paddingOnly(top: AppSize.appSize36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.dontHaveAccount,
                      style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(AppRoutes.registerView);
                      },
                      child: Text(
                        AppString.registerButton,
                        style: AppStyle.heading5Medium(color: AppColor.primaryColor),
                      ),
                    ),
                  ],
                ).paddingOnly(top: AppSize.appSize36)

              ],
            )
          ],
                ).paddingOnly(
          left: AppSize.appSize16,
          right: AppSize.appSize16,
                ),
        ),
        Positioned(
          top:  AppSize.appSize12,
          right: AppSize.appSize18,
          // alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.bottomBarView);
              },
              child:  const Text(AppString.skip,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                    fontSize: AppSize.appSize25,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.primaryColor,
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.solid),

              )
          ),
        ),
      ]
    );
  }

  Widget buildTextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.dontHaveAccount,
          style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
        ),
        GestureDetector(
          onTap: () {
            Get.offNamed(AppRoutes.registerView);
          },
          child: Text(
            AppString.registerButton,
            style: AppStyle.heading5Medium(color: AppColor.primaryColor),
          ),
        ),
      ],
    ).paddingOnly(bottom: 120);
  }
}

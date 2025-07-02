import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../common/common_button.dart';
import '../../common/common_rich_text.dart';
import '../../common/common_status_bar.dart';
import '../../common/common_textfield.dart';
import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/register_controller.dart';
import '../../controller/register_country_picker_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/text_segment_model.dart';
import '../../routes/app_routes.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  RegisterController registerController = Get.find<RegisterController>();
  RegisterCountryPickerController registerCountryPickerController = Get.put(RegisterCountryPickerController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: Obx( () {
           return  registerController.isOtpStep.value
                ? buildOtpInputSection(context)
           :buildRegisterFields(context);
          }),
          bottomNavigationBar: buildTextButton(),
        ),
        const CommonStatusBar(),
      ],
    );
  }




  Widget buildRegisterFields(BuildContext context) {
    return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSize.appSize10),
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
                Text(
                  AppString.register,
                  style: AppStyle.heading1(color: AppColor.textColor),
                ),
                Text(
                  AppString.registerString,
                  style: AppStyle.heading4Regular(color: AppColor.descriptionColor),
                ).paddingOnly(top: AppSize.appSize12, bottom: AppSize.appSize20),

                Obx(() => CommonTextField(
                  controller: registerController.fullNameController,
                  focusNode: registerController.focusNode,
                  hasFocus: registerController.hasFullNameFocus.value,
                  hasInput: registerController.hasFullNameInput.value,
                  hintText: AppString.fullName,
                  labelText: AppString.fullName,
                )),

                Obx(() => CommonTextField(
                  controller: registerController.phoneNumberController,
                  focusNode: registerController.phoneNumberFocusNode,
                  hasFocus: registerController.hasPhoneNumberFocus.value,
                  hasInput: registerController.hasPhoneNumberInput.value,
                  hintText: AppString.phoneNumber,
                  labelText: AppString.phoneNumber,
                  keyboardType: TextInputType.phone,
                )).paddingOnly(top: AppSize.appSize16),

                // Obx(() => Container(
                //   padding:  EdgeInsets.only(
                //     top: registerController.hasPhoneNumberFocus.value || registerController.hasPhoneNumberInput.value
                //         ? AppSize.appSize6 : AppSize.appSize14,
                //     bottom: registerController.hasPhoneNumberFocus.value || registerController.hasPhoneNumberInput.value
                //         ? AppSize.appSize8 : AppSize.appSize14,
                //     left: registerController.hasPhoneNumberFocus.value
                //         ? AppSize.appSize0 : AppSize.appSize16,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(AppSize.appSize12),
                //     border: Border.all(
                //       color: registerController.hasPhoneNumberFocus.value || registerController.hasPhoneNumberInput.value
                //           ? AppColor.primaryColor
                //           : AppColor.descriptionColor,
                //       width: AppSize.appSizePoint7,
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       registerController.hasPhoneNumberFocus.value || registerController.hasPhoneNumberInput.value
                //           ? Text(
                //         AppString.phoneNumber,
                //         style: AppStyle.heading6Regular(color: AppColor.primaryColor),
                //       ).paddingOnly(
                //         left: registerController.hasPhoneNumberInput.value
                //             ? (registerController.hasPhoneNumberFocus.value
                //             ? AppSize.appSize16 : AppSize.appSize0)
                //             : AppSize.appSize16,
                //         bottom: registerController.hasPhoneNumberInput.value
                //             ? AppSize.appSize2 : AppSize.appSize2,
                //       ) : const SizedBox.shrink(),
                //       Row(
                //         children: [
                //           registerController.hasPhoneNumberFocus.value || registerController.hasPhoneNumberInput.value ? SizedBox(
                //             // width: AppSize.appSize78,
                //             child: IntrinsicHeight(
                //               child: GestureDetector(
                //                 onTap: () {
                //                   registerCountryPickerBottomSheet(context);
                //                 },
                //                 child: Row(
                //                   children: [
                //                     Obx(() {
                //                       final selectedCountryIndex =
                //                           registerCountryPickerController.selectedIndex.value;
                //                       return Text(
                //                         registerCountryPickerController.countries[selectedCountryIndex]
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
                //             left: registerController.hasPhoneNumberInput.value
                //                 ? (registerController.hasPhoneNumberFocus.value
                //                 ? AppSize.appSize16 : AppSize.appSize0)
                //                 : AppSize.appSize16,
                //           ) : const SizedBox.shrink(),
                //           Expanded(
                //             child: SizedBox(
                //               height: AppSize.appSize27,
                //               width: double.infinity,
                //               child: TextFormField(
                //                 focusNode: registerController.phoneNumberFocusNode,
                //                 controller: registerController.phoneNumberController,
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
                //                   hintText: registerController.hasPhoneNumberFocus.value ? '' : AppString.phoneNumber,
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


                Obx(() => CommonTextField(
                  controller: registerController.emailController,
                  focusNode: registerController.emailFocusNode,
                  hasFocus: registerController.hasEmailFocus.value,
                  hasInput: registerController.hasEmailInput.value,
                  hintText: AppString.emailAddress,
                  labelText: AppString.emailAddress,
                )).paddingOnly(top: AppSize.appSize16),

                Obx(() => CommonTextField(
                  controller: registerController.passwordController,
                  hasFocus: registerController.hasPasswordFocus.value,
                  hasInput: registerController.hasPasswordInput.value,
                  hintText: AppString.password,
                  labelText: AppString.password,
                  obscureText: registerController.isPasswordHidden.value,
                  focusNode: registerController.passwordFocusNode,
                  suffixIcon: IconButton(
                      onPressed: (){
                        registerController.isPasswordHidden.value = !registerController.isPasswordHidden.value;
                      }, icon: Icon(
                    registerController.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                    size: AppSize.appSize30,
                  )),
                 )).paddingOnly(top: AppSize.appSize16),

                Obx(() => CommonTextField(
                  controller: registerController.confirmPasswordController,
                  hasFocus: registerController.hasConfirmPasswordFocus.value,
                  hasInput: registerController.hasConfirmPasswordInput.value,
                  hintText: AppString.confirmPassword,
                  labelText: AppString.confirmPassword,
                  obscureText: registerController.isConfirmPasswordHidden.value,
                  focusNode: registerController.confirmPasswordFocusNode,
                  suffixIcon: IconButton(
                      onPressed: (){
                        registerController.isConfirmPasswordHidden.value = !registerController.isConfirmPasswordHidden.value;
                      }, icon: Icon(
                    registerController.isConfirmPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                    size: AppSize.appSize30,
                  )),

                )).paddingOnly(top: AppSize.appSize16),

                // Text(
                //   AppString.areYouARealEstateAgent,
                //   style: AppStyle.heading5Regular(color: AppColor.textColor),
                // ).paddingOnly(top: AppSize.appSize16),
                // Row(
                //   children: List.generate(AppSize.size2, (index) {
                //     return GestureDetector(
                //       onTap: () {
                //         registerController.updateOption(index);
                //       },
                //       child: Obx(() => Container(
                //         margin: const EdgeInsets.only(right: AppSize.appSize16),
                //         height: AppSize.appSize37,
                //         width: AppSize.appSize75,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(AppSize.appSize12),
                //             border: Border.all(
                //               color: registerController.selectOption.value == index
                //                   ? Colors.transparent
                //                   : AppColor.descriptionColor,
                //             ),
                //             color: registerController.selectOption.value == index
                //                 ? AppColor.primaryColor
                //                 : Colors.transparent
                //         ),
                //         child: Center(
                //           child: Text(
                //             registerController.optionList[index],
                //             style: AppStyle.heading5Regular(
                //               color: registerController.selectOption.value == index
                //                   ? AppColor.whiteColor
                //                   : AppColor.descriptionColor,
                //             ),
                //           ),
                //         ),
                //       )),
                //     );
                //   }),
                // ).paddingOnly(top: AppSize.appSize10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        registerController.toggleCheckbox();
                      },
                      child: Obx(() => Image.asset(
                        registerController.isChecked.value
                            ? Assets.images.checkbox.path
                            : Assets.images.emptyCheckbox.path,
                        width: AppSize.appSize20,
                      )).paddingOnly(right: AppSize.appSize16),
                    ),
                    Expanded(
                      child: CommonRichText(
                        segments: [
                          TextSegment(
                            text: AppString.terms1,
                            style: AppStyle.heading6Regular(color: AppColor.descriptionColor),
                          ),
                          TextSegment(
                            text: AppString.terms2,
                            style: AppStyle.heading6Regular(color: AppColor.primaryColor),
                            onTap: (){
                             Get.toNamed(AppRoutes.termsOfUseView) ;
                            }
                          ),
                          TextSegment(
                            text: AppString.terms3,
                            style: AppStyle.heading6Regular(color: AppColor.descriptionColor),
                          ),
                          TextSegment(
                            text: AppString.terms4,
                            style: AppStyle.heading6Regular(color: AppColor.primaryColor),
                            onTap: (){
                              Get.toNamed(AppRoutes.privacyPolicyView) ;
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ).paddingOnly(top: AppSize.appSize16),
                // CommonButton(
                //   onPressed: () {
                //     otpVerificationBottomSheet(context);
                //   },
                //   child: Text(
                //     AppString.continueButton,
                //     style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                //   ),
                // ).paddingOnly(top: AppSize.appSize36),
                const SizedBox(height: 30,),
                Obx(()=>
                CommonButton(
                  onPressed: (){
                    if(registerController.isChecked.value){
                      registerController.registerUser();
                    } else {
                      Get.snackbar(
                           "Error",
                           "You must accept Terms & Conditions",
                      );
                    }
                  },
                  child: registerController.isLoading.value
                  ? const CircularProgressIndicator(color: AppColor.whiteColor,)
                      : Text(AppString.continueButton, style: AppStyle.heading5Medium(color: AppColor.whiteColor),)

                  ,
                )
                )

              ],
            ).paddingOnly(
              left: AppSize.appSize16, right: AppSize.appSize16,
            ),
          ),
        );
  }

  Widget buildOtpInputSection(BuildContext context) {
    return SingleChildScrollView(
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
          ).paddingOnly(bottom: AppSize.appSize20),
          Text(
            "Verify OTP",
            style: AppStyle.heading1(color: AppColor.textColor),
          ),
          Text(
            "Please enter the OTP sent to your phone number",
            style: AppStyle.heading4Regular(color: AppColor.descriptionColor),
          ).paddingOnly(top: AppSize.appSize12, bottom: AppSize.appSize36),
      
      
          PinCodeTextField(
            appContext: context,
            length: 4,
            controller: registerController.otpController,
            focusNode: registerController.otpFocusNode,
            autoFocus: true,
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            enableActiveFill: true,
            onChanged: (value) {
              registerController.hasOtpInput.value = value.length == 4;
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
      
          const SizedBox(height: 30),
          CommonButton(
            onPressed: () {
              registerController.verifyOtpAndRegisterUser();
            },
            child:  Obx(() => registerController.isLoading.value
                ? const CircularProgressIndicator(color: AppColor.whiteColor)
                : Text("Verify", style: AppStyle.heading5Medium(color: AppColor.whiteColor)),
            ))
        ],
      ).paddingOnly(top:AppSize.appSize100, right: AppSize.appSize20, left: AppSize.appSize20),
    );
  }


  Widget buildTextButton() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppString.alreadyHaveAnAccount,
              style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
            ),
            GestureDetector(
              onTap: () {
                Get.offNamed(AppRoutes.loginView);
              },
              child: Text(
                AppString.login,
                style: AppStyle.heading5Medium(color: AppColor.primaryColor),
              ),
            ),
          ],
        ).paddingOnly(bottom: AppSize.appSize26);
  }
}

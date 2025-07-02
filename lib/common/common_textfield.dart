import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../configs/app_color.dart';
import '../configs/app_size.dart';
import '../configs/app_style.dart';

class CommonTextField extends StatelessWidget {
  TextEditingController controller;
  FocusNode focusNode;
  bool hasFocus;
  bool hasInput;
  String hintText;
  String labelText;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  Function()? onTapCountryPicker;
  bool readOnly = false;
  BoxBorder? border;
  TextStyle? labelStyle;
  TextStyle? textfieldStyle;
  final bool obscureText;
  final Widget? suffixIcon;


  CommonTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasFocus,
    required this.hasInput,
    required this.hintText,
    required this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.onTapCountryPicker,
    this.readOnly = false,
    this.border,
    this.labelStyle,
    this.textfieldStyle,
    this.obscureText = false,
    this.suffixIcon

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: hasFocus || hasInput ? AppSize.appSize6 : AppSize.appSize14,
        bottom: hasFocus || hasInput ? AppSize.appSize8 : AppSize.appSize14,
        left: hasFocus ? AppSize.appSize0 : AppSize.appSize16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.appSize12),
        border: border ?? Border.all(
          color: hasFocus || hasInput ? AppColor.primaryColor : AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasFocus || hasInput)
            Padding(
              padding: EdgeInsets.only(
                left: hasInput ? (hasFocus ? AppSize.appSize16 : AppSize.appSize0) : AppSize.appSize16,
                bottom: hasInput ? AppSize.appSize2 : AppSize.appSize2,
              ),
              child: Text(
                labelText,
                style: labelStyle ?? AppStyle.heading6Regular(color: AppColor.primaryColor),
              ),
            ),
          SizedBox(
            height: AppSize.appSize27,
            child: TextFormField(
              focusNode: focusNode,
              controller: controller,
              obscureText: obscureText,
              cursorColor: AppColor.primaryColor,
              keyboardType: keyboardType,
              style: textfieldStyle ?? AppStyle.heading4Regular(color: AppColor.textColor),
              inputFormatters: inputFormatters,
              readOnly: readOnly,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: hasFocus ? AppSize.appSize16 : AppSize.appSize0,
                  vertical: AppSize.appSize0,
                ),
                isDense: true,
                hintText: hasFocus ? '' : hintText,
                hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: suffixIcon != null
                    ? Transform.translate(
                  offset: const Offset(0, -10),
                  child: suffixIcon,
                )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

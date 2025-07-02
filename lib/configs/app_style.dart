import 'package:flutter/material.dart';

import 'app_font.dart';
import 'app_size.dart';

class AppStyle {
  static TextStyle _baseStyle(
      double size, FontWeight weight, String fontFamily) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontFamily: fontFamily,
    );
  }

  static TextStyle appHeading({required Color color, required double letterSpacing}) {
    return _baseStyle(AppSize.appSize49, FontWeight.w700, AppFont.interBold)
        .copyWith(
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle heading1({required Color color}) {
    return _baseStyle(AppSize.appSize40, FontWeight.w700, AppFont.interBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading2({required Color color}) {
    return _baseStyle(AppSize.appSize25, FontWeight.w600, AppFont.interRegular)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading3({required Color color}) {
    return _baseStyle(AppSize.appSize18, FontWeight.w700, AppFont.interBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading3SemiBold({required Color color}) {
    return _baseStyle(AppSize.appSize18, FontWeight.w600, AppFont.interSemiBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading3Medium({required Color color}) {
    return _baseStyle(AppSize.appSize18, FontWeight.w500, AppFont.interMedium)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading3Regular({required Color color}) {
    return _baseStyle(AppSize.appSize18, FontWeight.w400, AppFont.interRegular)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading4SemiBold({required Color color}) {
    return _baseStyle(AppSize.appSize16, FontWeight.w600, AppFont.interSemiBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading4Medium({required Color color}) {
    return _baseStyle(AppSize.appSize16, FontWeight.w500, AppFont.interMedium)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading4Regular({required Color color}) {
    return _baseStyle(AppSize.appSize16, FontWeight.w400, AppFont.interRegular)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading5({required Color color}) {
    return _baseStyle(AppSize.appSize14, FontWeight.w700, AppFont.interBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading5SemiBold({required Color color}) {
    return _baseStyle(AppSize.appSize14, FontWeight.w600, AppFont.interSemiBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading5Medium({required Color color}) {
    return _baseStyle(AppSize.appSize14, FontWeight.w500, AppFont.interMedium)
        .copyWith(
      color: color,
    );
  }

  static TextStyle area({required Color color}) {
    return _baseStyle(AppSize.appSize18, FontWeight.w800, AppFont.interMedium)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading5Regular({required Color color}) {
    return _baseStyle(AppSize.appSize14, FontWeight.w400, AppFont.interRegular)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading6Bold({required Color color}) {
    return _baseStyle(AppSize.appSize12, FontWeight.w700, AppFont.interBold)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading6Medium({required Color color}) {
    return _baseStyle(AppSize.appSize12, FontWeight.w500, AppFont.interMedium)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading6Regular({required Color color}) {
    return _baseStyle(AppSize.appSize12, FontWeight.w400, AppFont.interRegular)
        .copyWith(
      color: color,
    );
  }

  static TextStyle heading7Regular({required Color color}) {
    return _baseStyle(AppSize.appSize10, FontWeight.w400, AppFont.interRegular)
        .copyWith(
      color: color,
    );
  }


  static TextStyle heading8Bold({required Color color,}) {
    return _baseStyle(AppSize.appSize26, FontWeight.w700, AppFont.interBold)
        .copyWith(
      color: color
    );
  }

  static TextStyle bodyTextStyle1({required Color color}){
    return _baseStyle(AppSize.appSize16, FontWeight.w400, AppFont.interRegular)
        .copyWith(
      color: color
    );

  }

  static TextStyle bodyTextStyle2({required Color color}){
    return _baseStyle(AppSize.appSize18, FontWeight.w400, AppFont.interRegular)
        .copyWith(
        color: color
    );

  }

  static TextStyle buttonTextStyle1({required Color color}){
    return _baseStyle(AppSize.appSize22, FontWeight.w700, AppFont.interBold)
        .copyWith(
        color: color
    );

  }


}
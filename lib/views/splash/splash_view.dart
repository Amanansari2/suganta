import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: buildSplash(),
    );
  }

  Widget buildSplash() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            "assets/myImg/tyilcom.png",
            width: AppSize.appSize355,
            height: AppSize.appSize150,
          ),
        ),
        // Text(
        //   AppString.appLogoName,
        //   style: AppStyle.appHeading(
        //     color: AppColor.primaryColor,
        //     letterSpacing: AppSize.appSize3,
        //   ),
        // ).paddingOnly(top: AppSize.appSize3),
      ],
    );
  }
}
